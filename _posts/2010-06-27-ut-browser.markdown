---
layout: post
title: Online Unreal Tournament server browser with pcntl fork()
archive: true
---

Another Unreal Tournament related script that I’ve been using for a long time.

Today I refactored the code to use `pcntl_fork()` in order to speed the script
up.

This is the only real multiprocessing facility offered by PHP, it is exactly
the same as the “classic” UNIX `fork()` function (See:
[/ext/pcntl/pcntl.c(541)][fork]). More advanced/efficient versions such as
`vfork()` or `rfork()` are not available.

Another method to handle this particular problem would be to connect in a
non-blocking mode, and use `stream_select()`. I chose to use fork because I
wanted to investigate PHP’s multiprocessing capabilities (which are pretty
much non-existent for almost any serious purpose).

Note: do not use `exit()` to exit the child process, use
`posix_kill(getmypid(), SIGKILL)` instead. For reasons not clear to me
`exit()` doesn't work when run from CGI, it exits the parent process too (It
does work when run from the commandline).

The code with fork
------------------

	<?php
	#
	# Martin Tournoij <martin@arp242.net>
	# Free for any use. There are no restrictions.
	#
	# Note: We use pcntl_fork(), you will need the pcntl PHP module.
	# Also note this will not work in Windows or if PHP is loaded as Apache module.
	#

	function Query($server, $cmd)
	{
		# http://wiki.beyondunreal.com/Legacy:UT_Server_Query

		$address = gethostbyname($server['0']);

		if (!$s = fsockopen('udp://' . $server['0'], $server['1'], $errno, $errstr, 2))
			return False;

		stream_set_timeout($s, 2);
		fputs($s, "\\$cmd\\");
		$info = fread($s, 8192);
		fclose($s);
		$info2 = explode('\\', "\\$info\\");

		foreach ($info2 as $k => $v)
		{
			if (empty($v) || $v == '' || $v == ' ')
				continue;
			if (is_int($k/2))
				$pv = $v;
			else
				$prettyinfo["$pv"] = htmlentities($v);

		}
		$prettyinfo['str'] = $info;

		return $prettyinfo;
	}

	function Server($s)
	{
		$info = Query($s, 'status');

		if (empty($info['str']))
		{
			# Just hide the entry, servers are often down
			#return "<tr><td colspan=\"4\">Could not connect to {$s['0']} {$s['1']}</td></tr>";
			return '';
		}

		if (isset($info['numplayers']))
		{
			$numplayers = $info['numplayers'] . " Players:<br />\n";
			$players = Query($s, 'players');

			for ($i=0; $i<=$info['maxplayers']; $i++)
			{
				$k = "player_$i";
				if ($players["$k"])
					$numplayers .= $players["$k"] . "<br />\n";
			}
		}
		else
			$numplayers = 'No players';

		# XXX Detect DTAS in a better way
		if ($info['gametype'] == 'INFCoopUnrealGame')
			$gametype = 'Coop';
		elseif ($info['gametype'] == 'INFg_EASGame')
			$gametype = 'EAS';
		elseif (stristr($info['hostname'], 'dtas'))
			$gametype = 'DTAS';
		elseif ($info['gametype'] == 'InfilTeamGamePlus')
			$gametype = 'TDM';
		else
			$gametype = $info['gametype'];

		$row = sprintf('<tr>
			<td><a href="ut-serverbrowse.php?server=%s:%s">%s</a><br />
			<span class="small">%s:%s</span></td>
			<td>%s</td>
			<td>%s</td>
			<td>%s</td>
			</tr>',
			$s['0'], $s['1'], $info['hostname'], $s['0'], $s['1'], $info['mapname'], $gametype, $numplayers);

		return $row;
	}

	function html($tbl)
	{
		if (stristr($_SERVER['HTTP_ACCEPT'], 'application/xhtml+xml'))
			$charset = 'application/xhtml+xml; charset=utf-8';
		else
			$charset = 'text/html; charset=utf-8';
		header("Content-Type: $charset");

		print '<?xml version="1.0" encoding="UTF-8"?>';
		printf('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
				"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
			<head>
				<meta http-equiv="Content-Type" content="%s" />
				<title>Infiltration Servers</title>
				<style type="text/css">
					table { border-collapse: collapse; margin: .25em; width: 95%%; }
					td, th, table, caption { border: 1px solid black; }
					tfoot td { border: none; font-size: .8em; }
					caption, th, tfoot { background-color: #ddd; }
					caption { font-weight: bold; }
					tr:hover { background-color: #eee; }
					div { border: 1px solid black; margin: .25em; width: 94%%; padding: .2em; margin-top: 2em; }
					label { width: 6em; }
					.small { font-size: .75em; margin-left: 2em; }
					p { width: 40em; }
				</style>
			</head>
			<body>
				<p>Refresh your browser and the list will be refreshed. Click on a link to
					refresh just that one server (faster).<br />
					Unfortunately, the list of players is often incomplete. This is not a
					bug on my side but one in the UT server. Sometimes trying for a few times can get you a
					larger list, but often not :(</p>

				<table summary="Infiltration servers">
					<caption>Infiltration servers</caption>
					<thead>
						<tr>
							<th scope="col">Server</th>
							<th scope="col">Map</th>
							<th scope="col">GameType</th>
							<th scope="col">Players</th>
						</tr>
					</thead>
					<tfoot>
						<tr>
							<td colspan="4">List fetched on %s
								| <a href="ut-serverbrowse-fork.php.txt">View source</a></td>
						</tr>
					</tfoot>
					<tbody>
						%s
					</tbody>
				</table>

				<form method="post" action="%s">
					<div>
						<label for="server">Manually enter server to query. <em>address:port</em>: </label>
						<input type="text" id="server" name="server" value="%s"/>
						<input type="submit" value="Query" />
					</div>
				</form>', $charset, date('r'), $tbl, $_SERVER['PHP_SELF'], $_GET['server']);

		if (isset($_GET['server']))
			printf('<p><a href="%s">Back to main</a></p>', $_SERVER['PHP_SELF']);

		print '</body></html>';
	}

	# We do not use a masterserver but maintain the list here manually; This is a
	# feature and not a bug because the masterserver for the mod I play
	# (Infiltration) is not particularly reliable.
	$servers = array(
		array('cerberon.net', 17778), # coop1
		array('cerberon.net', 27778), # coop2
		array('90.184.183.249', 7778), # wargamez
		array('xplod.de', '7778'), # xplod
		array('xplod.de', '8889'), # xplod2
		array('84.255.245.128', '7778') # planetweed
	);

	if (isset($_POST['server']))
		$_GET['server'] = $_POST['server'];

	if (isset($_GET['server']))
	{
		$a = explode(':', $_GET['server']);
		$servers = array(array($a['0'], $a['1']));
	}

	$mypid = getmypid();
	$procs = array();
	$tmp = tempnam(sys_get_temp_dir(), 'SERVERBROWSE_');
	$fp = fopen($tmp, 'w+');
	foreach ($servers as $s)
	{
		$pid = pcntl_fork();

		if ($pid == -1)
		{
			print 'Unable to fork. Exiting';
			exit(1);
		}

		if ($pid == 0)
		{
			$data = Server($s);
			fwrite($fp, $data) . "\n";
			posix_kill(getmypid(), 9);
		}
		else
			array_push($procs, $pid);
	}

	# Wait for all childs to finish
	while (count($procs) > 0)
	{
		$pid = pcntl_waitpid(-1, $status, WNOHANG);

		foreach($procs as $k => $p)
		{
			if($pid == $p)
				unset($procs[$k]);
		}
		usleep(250);
	}

	fclose($fp);

	$fp = fopen($tmp, 'r');
	$tbl = '';
	while ($buf = fread($fp, 8192))
		$tbl .= $buf;
	fclose($fp);
	unlink($tmp);

	html($tbl);
	exit(0);

The code without fork
---------------------

This is the old version without forking, it’s slower but since
`pcntl_fork()` is not always available it may still be of some interest.

	<?php
	#
	# Martin Tournoij <martin@arp242.net>
	# Free for any use. There are no restrictions.
	#

	function Query($server, $cmd)
	{
		# http://wiki.beyondunreal.com/Legacy:UT_Server_Query

		$address = gethostbyname($server['0']);

		if (!$s = fsockopen('udp://' . $server['0'], $server['1'], $errno, $errstr, 2))
			return False;

		stream_set_timeout($s, 2);
		fputs($s, "\\$cmd\\");
		$info = fread($s, 8192);
		fclose($s);
		$info2 = explode('\\', "\\$info\\");

		foreach ($info2 as $k => $v)
		{
			if (empty($v) || $v == '' || $v == ' ')
				continue;
			if (is_int($k/2))
				$pv = $v;
			else
				$prettyinfo["$pv"] = htmlentities($v);

		}
		$prettyinfo['str'] = $info;

		return $prettyinfo;
	}

	# We do not use a masterserver but maintain the list here manually; This is a
	# feature and not a bug because the masterserver for the mod I play
	# (Infiltration) is not particularly reliable.
	$servers = array(
		array('cerberon.net', 17778), # coop1
		array('cerberon.net', 27778), # coop2
		array('90.184.183.249', 7778), # wargamez
		array('xplod.de', '7778'), # xplod
		array('xplod.de', '8889'), # xplod2
		array('84.255.245.128', '7778') # planetweed
	);

	if (isset($_POST['server']))
		$_GET['server'] = $_POST['server'];

	if (isset($_GET['server']))
	{
		$a = explode(':', $_GET['server']);
		$servers = array(array($a['0'], $a['1']));
	}

	$tbl = array();
	foreach ($servers as $s)
	{
		$info = Query($s, 'status');

		if (empty($info['str']))
		{
			# Just hide the entry, servers are often down
			#$tbl .= "<tr><td colspan=\"4\">Could not connect to {$s['0']} {$s['1']}</td></tr>";
			continue;
		}

		if (isset($info['numplayers']))
		{
			$numplayers = $info['numplayers'] . " Players:<br />\n";
			$players = Query($s, 'players');

			for ($i=0; $i<=$info['maxplayers']; $i++)
			{
				$k = "player_$i";
				if ($players["$k"])
					$numplayers .= $players["$k"] . "<br />\n";
			}
		}
		else
			$numplayers = 'No players';

		# XXX Detect DTAS in a better way
		if ($info['gametype'] == 'INFCoopUnrealGame')
			$gametype = 'Coop';
		elseif ($info['gametype'] == 'INFg_EASGame')
			$gametype = 'EAS';
		elseif (stristr($info['hostname'], 'dtas'))
			$gametype = 'DTAS';
		elseif ($info['gametype'] == 'InfilTeamGamePlus')
			$gametype = 'TDM';
		else
			$gametype = $info['gametype'];

		$tbl[] = sprintf('<tr>
			<td><a href="ut-serverbrowse.php?server=%s:%s">%s</a><br />
			<span class="small">%s:%s</span></td>
			<td>%s</td>
			<td>%s</td>
			<td>%s</td>
			</tr>',
			$s['0'], $s['1'], $info['hostname'], $s['0'], $s['1'], $info['mapname'], $gametype, $numplayers);
	}

	$tbl = implode('', $tbl);
	if (stristr($_SERVER['HTTP_ACCEPT'], 'application/xhtml+xml'))
		$charset = 'application/xhtml+xml; charset=utf-8';
	else
		$charset = 'text/html; charset=utf-8';
	header("Content-Type: $charset");
	?>
	<?php echo '<?xml version="1.0" encoding="UTF-8"?>' ?>
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
		"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
		<head>
			<meta http-equiv="Content-Type" content="<?php print $charset; ?>" />
			<title>Infiltration Servers</title>
			<style type="text/css">
				table { border-collapse: collapse; margin: .25em; width: 95%; }
				td, th, table, caption { border: 1px solid black; }
				tfoot td { border: none; font-size: .8em; }
				caption, th, tfoot { background-color: #ddd; }
				caption { font-weight: bold; }
				tr:hover { background-color: #eee; }
				div { border: 1px solid black; margin: .25em; width: 94%; padding: .2em; margin-top: 2em; }
				label { width: 6em; }
				.small { font-size: .75em; margin-left: 2em; }
				p { width: 40em; }
			</style>
		</head>
		<body>
			<p>Refresh your browser and the list will be refreshed. Click on a link to
				refresh just that one server (faster).<br />
				Unfortunately, the list of players is often incomplete. This is not a
				bug on my side but one in the UT server. Sometimes trying for a few times can get you a
				larger list, but often not :(</p>

			<table summary="Infiltration servers">
				<caption>Infiltration servers</caption>
				<thead>
					<tr>
						<th scope="col">Server</th>
						<th scope="col">Map</th>
						<th scope="col">GameType</th>
						<th scope="col">Players</th>
					</tr>
				</thead>
				<tfoot>
					<tr>
						<td colspan="4">List fetched on <?php print date('r'); ?>
							| <a href="ut-serverbrowse.php.txt">View source</a></td>
					</tr>
				</tfoot>
				<tbody>
					<?php print $tbl; ?>
				</tbody>
			</table>

			<form method="post" action="<?php print $_SERVER['PHP_SELF'] ?>">
				<div>
					<label for="server">Manually enter server to query. <em>address:port</em>: </label>
					<input type="text" id="server" name="server" value="<?php print $_GET['server'] ?>"/>
					<input type="submit" value="Query" />
				</div>
			</form>

			<?php if (isset($_GET['server'])) { ?>
				<p><a href="<?php print $_SERVER['PHP_SELF'] ?>">Back to main</a></p>
			<?php } ?>

		</body>
	</html>

[fork]: http://svn.php.net/viewvc/php/php-src/branches/PHP_5_3//ext/pcntl/pcntl.c?view=markup#l541
