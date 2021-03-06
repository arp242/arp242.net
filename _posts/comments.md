---
title: "Good comments read well and are to the point"
date: 2019-12-05
updated: "2019-12-15"
tags: ["Programming"]
---

Good comments should read well, be to the point, and don't faff about with
needless verbiage. This [applies to any writing][better-writer] but doubly so
for technical documentation and triply so for comments.

Quick example I found today:

    // This block represents the list of errors that could be raised when using
    // the webhook package.

Can be rephrased as:

    // Possible errors when validating a webhook.

The default comment is *adequate*, but is a bit of a mouthful and can easily be
rephrased to contain the exact same information. Why use more words if you don't
need to? It's only distracting from the actual information you want to convey.

I don't want to make the case to "use comment as little as possible" here –
that's a different discussion – just that comments should be to the point, and
not faff about. The worst offenders is fluff like *"Okay, let me explain what
this function does [..]"*, *"This function will [..]"*, *"This setting will
control [..]"*, *"Now that we are here [..]"*. None of that adds any value.

---

It's important to form sentences that read well. *"if this condition is true,
then do something"* makes sense if you follow the code, but "*do something if
condition"* is both shorter and usually reads more naturally. Comments sometimes
seem like an unedited "stream of consciousness" that the programmer made while
writing the code which were never edited to more standard language after being
written.

Writing is hard and takes practice, but being attentive improves much of it and
avoids the worst cases. I find that in my own comments the first attempt is
often sub-optimal or downright bad, and requires some effort to get it right.
Reading comments out loud helps a lot (this, again, is [general writing
advice][read-aloud]).

It's probably best to avoid slang, sayings, idioms, literary imagery, etc. as
well. Your goal is to convey ideas, not to write an entertaining novel. I worked
for an Irish company for three years, and was hella confused by all the
[craic][craic] my Irish coworkers wrote in the comments.

Spell check your comments. Yeah, misspelling "request" as "requst" isn't a huge
deal, but it does impede readability. Might as well get it right.

Code reviews should address comments just as the code, although I wouldn't
recommend being *too* pedantic about this. In the end, there is quit a lot of
subjectivity involved in "good" writing.

---

While I don't really want to enter the debate on *when* to comment in depth,
some comments are truly redundant. Some of the silliest examples I have seen:

    char buf[BUF_SIZE]; /* create an array of characters */

    transaction.Commit() // commit the transaction

    // Start the loop.
    while ( have_posts() ) : the_post();

    [..]

    // End the loop.
    endwhile;

----

Keep comments updated. If the code is updated, then also update the comment.
Here’s some code I once encountered:

    /**
     * Please be careful when modifying this function. This is really advanced code.
     * @return bool
     */
    public static function initResources()
    {
        return true;
    }

While this example is obvious (even [made it to The Daily WTF][tdwtf]), most are
more subtle.


Some examples
-------------

Some random examples I encountered.

<style>
.examples > div { margin-top: 1em; }
.examples > div > span { }
.examples > div > pre { margin: 0; }
.examples > div > pre:nth-child(2) { border: none; background-color: #ffdbdb; }
.examples > div > pre:nth-child(3) { border: none; background-color: #d9ffd9; }
</style>

<div class="examples">
<div><span>Waffling:</span>
<pre>// For card errors resulting from a card issuer decline, a short string
// indicating the card issuer’s reason for the decline if they provide
// one.</pre>
<pre>// Card issuer's reason for declining a card, if provided.</pre>
</div>

<div><span>Waffling:</span>
<pre>// DefaultTolerance indicates that signatures older than this will be rejected by ConstructEvent.</pre>
<pre>// Reject signatures older than this.</pre>
</div>


<div><span>Awkward English:</span>
<pre># we want the modal to be draggable except if it's a fixed one</pre>
<pre># The modal should be draggable unless it's fixed.</pre>
</div>

<div><span>Needless language:</span>
<pre>// If we're at this point, we should tell the client's browser what to send
// up in future</pre>
<pre>// Tell the client's browser what to send in future.</pre>
</div>

<div><span>Needless language:</span>
<pre>// Ok, we are good, so lets go ahead and start the merge now.
// Let's go ahead and remove duplicate threads</pre>
<pre>// Remove duplicate threads.</pre>
</div>

<div><span>Needless language</span>
<pre>// Before saving, check if this reply was from a forward to a 3rd party. If
// it was, then we need to save this as a note, not as a message</pre>
<pre>// Save as note if this reply was forwarded from a third party.</pre>
</div>

<div><span>Confusing typo:</span>
<pre>// good change it'll be cached</pre>
<pre>// Good chance it's cached.</pre>
</div>

<div><span>Confusing language</span>
<pre>if action.Notify.Subject == "" { // if subject is empty, it's mean that the user want a copy only</pre>
<pre>if action.Notify.Subject == "" { // The users wants only a copy if the subject is empty.</pre>
</div>

<div><span>Confusing language; excessively verbose.</span>
<pre>// This will check if the actual requst path ends in .json. If the router
// path that we defined ends in .json and the actual request URL does not
// end in .json, then we want to make this a not found error as it's not
// the correct URL.</pre>
<pre>// Make sure that "/foo/42" does *NOT* work when the route is
// "/foo/:id.json".</pre>
</div>

<div><span>Confusing slang, I think? I don't have an alternative as I'm not sure
what it's trying to say</span>
<pre>// So we can't limit this in future cause it's horse</pre>
</div>

<div><span>Overly verbose:</span>
<pre>// RoundPlus will round  your float given the precision you specify: RoundPlus(7.258,2) will return 7.26</pre>
<pre>// RoundPlus will round the value to the given precision.</pre>
</div>

<div><span>Confusing:</span>
<pre>" get count of the motion. This should be done before all the normal
" expressions below as those reset this value(because they have zero
" count!). We abstract -1 because the index starts from 0 in motion.</pre>
<pre>" Get motion count; done here as some commands later on will reset it.
" -1 because the index starts from 0 in motion.</pre>
</div>

<div><span>Verbose:</span>
<pre>// Let's do a little bit of security before we try the delete.  Make sure that all of the tickets
// that are being passed in are valid tickets that the user can delete.</pre>
<pre>// Make sure the user is allowed to delete the tickets.</pre>
</div>

<div><span>Verbose:</span>
<pre>// Assert that the threads is bigger than 1 At this point there should
// be 2 threads in there - the original and this new one here
if numThreads < 1 {</pre>
<pre>// There should be two threads: the original and the new one.
if numThreads < 1 {</pre>
</div>

<div><span>Confusing:</span>
<pre>// findPhishingURLs finds all of the links in a given html string and returns a
// list of those that are known phising URLs.</pre>
<pre>// findPhishingURLs finds all known phising URLs in an HTML string.</pre>
</div>

<div><span>Verbose, confusing:</span>
<pre>// activityDeadline is the duration that an http request to any activity
// endpoint must complete within</pre>
<pre>// Maximum duration for activity endpoints.</pre>
</div>

<div><span>Confusing, verbose:</span>
<pre># If we're pressing the down key and the next node is not
# content editable (i.e the signature box), then we want to fix
# the broken contenteditable behaviour by setting the cursor from
# where it is now to the end of the current node.</pre>
<pre># The down key won't go to the end of line if the next node isn't
# contenteditable. This seems like a WebKit-specific bug we have to
# work around.</pre>
</div>

</div>


[stripe]: https://stripe.com/docs/api/errors
[better-writer]: https://dilbertblog.typepad.com/the_dilbert_blog/2007/06/the_day_you_bec.html
[read-aloud]: https://www.standoutbooks.com/reading-aloud-improve-writing/
[syntax]: https://jameshfisher.com/2014/05/11/your-syntax-highlighter-is-wrong
[tdwtf]: http://thedailywtf.com/articles/Comments?-and-Log-MessagesOH-MY!&-Errors
[craic]: https://en.wikipedia.org/wiki/Craic
