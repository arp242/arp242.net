---
title: "Getting started with RimWorld modding on Linux"
date: 2021-09-29
filetype: xml
tags: ['RimWorld']
---

This describes how to create RimWorld mods on Linux; this is an introduction to
both RimWorld modding and developing C♯ with Mono; it's essentially the steps I
followed to get started.

This doesn't assume any knowledge of Unity, Mono, or C♯ but some familiarity
with Linux and general programming is assumed; if you're completely new to
programming then this probably isn't a good resource. A lot of this will work on
Windows or macOS too; it's just the C♯ build steps that are really
Linux-specific, as are various pathnames etc.

RimWorld mods consist of two parts:

- A set of XML definitions ("Defs") which defines everything from items, actions
  you can take, research projects, weather, etc. This is the "glue" that
  actually makes stuff appear in the game, applies effects, etc.

  For (very) simple mods this may actually be enough, and no "real" coding is
  required. You can use XML files to both add new stuff, and RimWorld has
  facilities to patch existing in-game content.

- C♯ code which either adds entire new stuff, or monkey-patches existing code.

As an example we'll make a little mod that makes it rain blood. Why? It seemed
easy enough to do while also exploring some of the core concepts. Also, I was
playing Slayer when I started on this. The [complete example mod is on
GitHub][rb], but I encourage people to modify things manually (and maybe play
around with things a bit) rather than copy/paste stuff from there; it's just a
better way to learn things.

[rb]: https://github.com/arp242/RimWorld-RainingBlood

Getting started
---------------
Before we start with the C♯ stuff let's set up a basic mod which adds a new
weather type; we just need to edit some XML for this.

Mods are located in the `Mods/` directory in your RimWorld installation
directory; I'm using the version I bought from the RimWorld website and
extracted to `~/rimworld` so that's nice and simple. GOG.com games usually store
the actual game data in a `game/` subdirectory, and I don't know where Steam
stores things 🤷

This directory should already exist with a `Mods/Place mods here.txt`. A mod
*must* have an `About/About.xml` file; a minimal version looks like:

    <?xml version="1.0" encoding="utf-8"?>
    <ModMetaData>
        <!-- Must contain a dot; usually <author>.<modname> -->
        <packageId>arp242.RainingBlood</packageId>
        <name>Raining blood</name>

        <!-- Game versions this mod supports. More on game versions later. -->
        <supportedVersions>
            <li>1.1</li>
            <li>1.2</li>
            <li>1.3</li>
        </supportedVersions>
    </ModMetaData>

See `ModUpdating.txt` in the RimWorld installation directory for a full
description of the `About.xml` fields. For now, this is enough.

{% warning %}
Pathnames are *case-sensitive*; `about/about.xml` will not work. If a pathname
has a capital in it then chances are you are *required* to write it with a
capital. Many pathnames start with a capital, as seems common in the C♯ world.
Keep this in mind if something doesn't work!
{% endwarning %}

The official content uses essentially the same structure as a mod except that
it's in the `Data/` directory; e.g. `Data/Core/` contains the base game,
`Data/Royalty` the Royalty expansion, etc. To find the weather definitions I
just used:

{:class="ft-none"}
    [~/rimworld/Data/Core]% ls (#i)**/*weather*.xml
    Defs/WeatherDefs/Weathers.xml

The `(#i)` makes things case-insensitive in zsh, FYI. zsh is nice. You can also
use `find -iname` if you enjoy more typing.

`Weathers.xml` seems to define all the weather types. I copied the definition of
"rain" to `Mods/RainingBlood/Defs/WeatherDefs/RainingBlood.xml` with some
modifications:

    <?xml version="1.0" encoding="utf-8" ?>
    <Defs>
	<WeatherDef>
		<defName>RainingBlood</defName>
		<label>raining blood</label>
		<description>It's raining blood; what the hell?!</description>

        <!-- ThoughtDefs/RainingBlood.xml -->
        <!-- <exposedThought>SoakingWet</exposedThought> -->
		<exposedThought>BloodCovered</exposedThought>

		<!-- Copied from rain -->
		<temperatureRange>0~100</temperatureRange>
		<windSpeedFactor>1.5</windSpeedFactor>
		<accuracyMultiplier>0.8</accuracyMultiplier>
		<favorability>Neutral</favorability>
		<perceivePriority>1</perceivePriority>

		<rainRate>1</rainRate>
		<moveSpeedMultiplier>0.9</moveSpeedMultiplier>
		<ambientSounds>
			<li>Ambient_Rain</li>
		</ambientSounds>
		<overlayClasses>
			<li>WeatherOverlay_Rain</li>
		</overlayClasses>
		<commonalityRainfallFactor>
			<points>
				<li>(0, 0)</li>
				<li>(1300, 1)</li>
				<li>(4000, 3.0)</li>
			</points>
		</commonalityRainfallFactor>

		<!-- Colours modified to be reddish; just a crude effect. -->
		<skyColorsDay>
			<sky>(0.8,0.2,0.2)</sky>
			<shadow>(0.92,0.2,0.2)</shadow>
			<overlay>(0.7,0.2,0.2)</overlay>
			<saturation>0.9</saturation>
		</skyColorsDay>

		<skyColorsDusk>
			<sky>(1,0,0)</sky>
			<shadow>(0.92,0.2,0.2)</shadow>
			<overlay>(0.6,0.2,0.2)</overlay>
			<saturation>0.9</saturation>
		</skyColorsDusk>

		<skyColorsNightEdge>
			<sky>(0.35,0.10,0.15)</sky>
			<shadow>(0.92,0.22,0.22)</shadow>
			<overlay>(0.5,0.1,0.1)</overlay>
			<saturation>0.9</saturation>
		</skyColorsNightEdge>

		<skyColorsNightMid>
			<sky>(0.35,0.20,0.25)</sky>
			<shadow>(0.92,0.22,0.22)</shadow>
			<overlay>(0.5,0.2,0.2)</overlay>
			<saturation>0.9</saturation>
		</skyColorsNightMid>
	</WeatherDef>
    </Defs>

The location where you store it doesn't actually matter as long as it's in
`Defs`; `Defs/xxx.xml` will work too. Internally all XML files in `Defs/` are
scanned in the same data structure; it just recursively searches for `*.xml`
files and uses `<defName>RainingBlood</defName>` to identify them rather than
the path.

It's not very fancy. We also need a new "exposed thought"; that's the mood
modifier that shows up in the "needs" tab; "Soaking wet" doesn't really seem
applicable if you're "soaking wet in blood" 🙃

Let's grep for it:

{:class="ft-cli"}
    [~/rimworld/Data/Core]% rg SoakingWet
    Defs/TerrainDefs/Terrain_Water.xml
    12:    <traversedThought>SoakingWet</traversedThought>

    Defs/ThoughtDefs/Thoughts_Memory_Misc.xml
    297:    <defName>SoakingWet</defName>

    Defs/WeatherDefs/Weathers.xml
    98:    <exposedThought>SoakingWet</exposedThought>
    202:    <exposedThought>SoakingWet</exposedThought>
    267:    <exposedThought>SoakingWet</exposedThought>

`Thoughts_Memory_Misc.xml` seems to be what we want, so make a copy of that to
`Mods/RainingBlood/Defs/ThoughtDefs/RainingBlood.xml`:

    <?xml version="1.0" encoding="utf-8" ?>
    <Defs>
    <ThoughtDef>
        <defName>BloodCovered</defName>
        <durationDays>0.1</durationDays>
        <stackLimit>1</stackLimit>
        <stages>
            <li>
                <label>blood covered</label>
                <description>I'm covered in blood; yuk!</description>
                <baseMoodEffect>-30</baseMoodEffect>
            </li>
        </stages>
    </ThoughtDef>
    </Defs>

The meaning of the fields in both XML files should be mostly self-explanatory,
but if you want to know what *exactly* something does you'll need to decompile
the game to read the source code. We'll cover that later.

At this point, the basic mod should be done; let's test it.

### Running the game
Start the name normally and select the mod in the Mods panel. After this you can
start the game with `./RimworldLinux -quicktest`, which will start the game in a
new small map with the last selected mods.

You can select "Development mode" in options, which will give you a few buttons
at the top, it will also allow you to open the console with <code>`</code> and
you can speed up things a wee bit more by pressing 4 (*ludicrous speed!*) Most
of the buttons etc. should be self-explanatory; there's some [more information
on the RimWorld wiki][devmode].

Click the "debug actions" button at the top, which has "Change Weather" (filter
in the top-left corner; you may need to scroll down). After clicking RainBlood
it takes a few seconds for the weather to transition and the status to show up
in your colonists.

[devmode]: https://rimworldwiki.com/wiki/Development_mode

### Patching the biomes
It's all very good that we can select this from our magical debug actions, but
does it actually appear in a regular game? Let's search where the
`RainyThunderstorm` weather is referenced (as that's a bit more unique than just
"rain"):

{:class="ft-cli"}
    [~/rimworld/Data/Core]% rg RainyThunderstorm
    Defs/BiomeDefs/Biomes_Cold.xml
    101:      <RainyThunderstorm>1</RainyThunderstorm>
    234:      <RainyThunderstorm>1</RainyThunderstorm>
    389:      <RainyThunderstorm>1</RainyThunderstorm>
    513:      <RainyThunderstorm>0</RainyThunderstorm>
    611:      <RainyThunderstorm>0</RainyThunderstorm>

    Defs/BiomeDefs/Biomes_Temperate.xml
    104:      <RainyThunderstorm>1</RainyThunderstorm>
    262:      <RainyThunderstorm>1</RainyThunderstorm>

    Defs/BiomeDefs/Biomes_Warm.xml
    109:      <RainyThunderstorm>1.7</RainyThunderstorm>
    277:      <RainyThunderstorm>1.7</RainyThunderstorm>

    Defs/BiomeDefs/Biomes_WarmArid.xml
    79:      <RainyThunderstorm>1</RainyThunderstorm>
    204:      <RainyThunderstorm>1</RainyThunderstorm>
    312:      <RainyThunderstorm>1</RainyThunderstorm>

    Defs/WeatherDefs/Weathers.xml
    193:    <defName>RainyThunderstorm</defName>

e.g. `Biomes_Cold.xml` has:

    <baseWeatherCommonalities>
        <Clear>18</Clear>
        <Fog>1</Fog>
        <Rain>2</Rain>
        <DryThunderstorm>1</DryThunderstorm>
        <RainyThunderstorm>1</RainyThunderstorm>
        <FoggyRain>1</FoggyRain>
        <SnowGentle>4</SnowGentle>
        <SnowHard>4</SnowHard>
    </baseWeatherCommonalities>

Now let's try adding our bloody rain with a high chance of spawning:

    <baseWeatherCommonalities>
        <Clear>18</Clear>
        <Fog>1</Fog>
        <Rain>2</Rain>
        <DryThunderstorm>1</DryThunderstorm>
        <RainyThunderstorm>1</RainyThunderstorm>
        <FoggyRain>1</FoggyRain>
        <SnowGentle>4</SnowGentle>
        <SnowHard>4</SnowHard>

        <RainingBlood>64</RainBlood> <!-- References the defName -->
    </baseWeatherCommonalities>

Why 64? Well, the other numbers add up to 32 and if they're relative weights
then 64 means a 2/3rd chance of our raining blood weather. "Trying it and seeing
what happens" is pretty much what I'm doing here. Throw enough macaroni at a
wall and sooner or later some of it will stick.[^weight]

[^weight]: Although I later did confirm that they're relative weights, see
           `Verse.TryRandomElementByWeight()`, which can be examined after
           decompiling the source, which we'll cover later.

The easiest way to override this is to copy the XML file to your
`Mods/[..]/Defs/` directory. Again, the path doesn't matter, it just looks at
the `defName` attribute; the last one overrides any previous ones.

This is pretty useful for testing, debugging, etc. as you can focus on just the
XML without worrying if it's patched correctly. The obvious downside is that you
won't include any future updates (which may break the game due to missing fields
etc.), and if someone decides to make a "RainingMen" mod then one will override
the other, and you can't have both mods. You never want to do this in a
published mod, but for testing it's useful.

Testing this is a bit annoying, since you need to wait for it to take effect.
Also, it seems the game always sets the initial weather for at least 10 in-game
days, so you may want to load a save game instead of using `-quicktest`.
Remember You can press `4` for if you enabled the dev console, which speeds up
the game to 15× (`3` is 6×). You can also make `4` speed it up to a whopping
150× by going to the "TweakValues" developer menu and enabling
`TickManager.UltraSpeedBoost`. I am disappointed this is called `UltraFast` and
`UltraSpeedBoost` instead of `RidiculousSpeed` and `LudicrousSpeed`.

After confirming that our "override it all"-method works let's properly patch
stuff. There are [several ways of patching XML resources][patch]; I'll use XPath
here, which is the easiest if you just need to patch some XML. Any XML file in
`Patches/` is treated as patch.

Our patch will just all biomes in `Patches/Biomes.xml`, but you can select for
`[defName=..]` if you only want to patch specific ones. Remember to remove the
overrides if you have any.

    <?xml version="1.0" encoding="utf-8" ?>
    <Patch>
    <!-- Class, not class! -->
    <Operation Class="PatchOperationAdd">
        <xpath>/Defs/BiomeDef/baseWeatherCommonalities</xpath>
        <value>
            <RainingBlood>64</RainingBlood>
        </value>
    </Operation>
    </Patch>

As previously mentioned all XML files in `Defs/` are in the same data structure,
so don't worry about the pathnames. There are a number of other operations you
can do; see [the full documentation][xpath] for more details on how patching
works.

{% warning %}
Do not start XPath expressions with `//` as [it's very slow](https://ludeon.com/forums/index.php?topic=32874.0).
{% endwarning %}

You can use `xmllint` from libxml2 to test queries on the commandline:

    % xmllint --xpath '/Defs/BiomeDef/baseWeatherCommonalities' \
        Data/Core/Defs/BiomeDefs/Biomes_Cold.xml

[patch]: https://rimworldwiki.com/wiki/Modding_Tutorials/Modifying_defs
[xpath]: https://rimworldwiki.com/wiki/Modding_Tutorials/PatchOperations

Writing C♯ code
---------------
Let's expand the mod a bit by making cannibals *like* raining blood and give
them a mood boost, rather than a mood penalty. There isn't any way to express
that in the XML defs, so we need some code for that.

### Decompiling the code
Some of the game's source code is in the installation directory (e.g.
`~/rimworld/Source`) but it's not a lot; there's
`Source/Verse/Defs/DefTypes/WeatherDef.cs`, but it's not all that useful. You
can more or less ignore this directory.

To actually figure out how to write mods we'll need to decompile the C♯ code in
`RimWorldLinux_Data/Managed/Assembly-CSharp.dll`.[^eula] There are [several
tools][decomp] for this; I'll use [ILSpy]. This doesn't seem [packaged in most
distros][ilspy-pkg] but there are Linux binaries for the GUI available as
[AvaloniaILSpy]. This seems to work well enough, but I prefer to extract all the
code at once so I can use Vim and grep and whatnot, and the GUI doesn't seem to
do that (there is "save code", but that doesn't seem to do anything). 

[decomp]: https://rimworldwiki.com/wiki/Modding_Tutorials/Decompiling_source_code

[^eula]: Explicitly allowed in [the EULA](https://rimworldgame.com/eula/) it
         turns out: *"You're allowed to 'decompile' our game assets and look
         through our code, art, sound, and other resources for learning
         purposes, or to use our resources as a basis or reference for a Mod.
         However, you're not allowed to rip these resources out and pass them
         around independently."* I wish they'd just make this easier by
         distributing more code, but ah well.

[ILSpy]: https://github.com/icsharpcode/ILSpy
[AvaloniaILSpy]: https://github.com/icsharpcode/AvaloniaILSpy
[ilspy-pkg]: https://repology.org/project/ilspy

You need to build the `ilspycmd` binary from source, there isn't a pre-compiled
version as far as I can find. Basic instructions:

{:class="ft-cli"}
    # The ".NET home".
    % export DOTNET_ROOT=$HOME/dotnet
    % mkdir -p $DOTNET_ROOT

    # Needs .NET SDK 5 and .NET Core 3.1; binaries from:
    #   https://dotnet.microsoft.com/download/dotnet/5.0
    #   https://dotnet.microsoft.com/download/dotnet/3.1
    # Versions may be different; this is just indicative.
    % tar xf dotnet-sdk-5.0.401-linux-x64.tar.gz -C $DOTNET_ROOT
    % tar xf dotnet-sdk-3.1.413-linux-x64.tar.gz -C $DOTNET_ROOT

    # Add the dotnet path, the binaries we compile later will be in ~/.dotnet/tools
    % export PATH=$PATH:$HOME/dotnet:$HOME/.dotnet/tools

    # Just the "source code" tar.gz from the GitHub release:
    # https://github.com/icsharpcode/ILSpy/archive/refs/tags/v7.1.tar.gz
    % tar xf ILSpy-7.1.tar.gz
    % cd ILSpy-7.1
    % dotnet tool install ilspycmd -g

    # Now decompile the lot to src.
    % cd ~/rimworld
    % mkdir src
    % ilspycmd ./RimWorldLinux_Data/Managed/Assembly-CSharp.dll -p -o src

    # Hurray!
    % ls src
    Assembly-CSharp.csproj       FleckUtility.cs         RimWorld/
    ComplexWorker_Ancient.cs     HistoryEventUtility.cs  Verse/
    ComplexWorker.cs             Ionic/                  WeaponClassDef.cs
    DarknessCombatUtility.cs     Properties/             WeaponClassPairDef.cs
    FleckParallelizationInfo.cs  ResearchUtility.cs

You only need to do this once. Note that the `DOTNET_ROOT` is a runtime
dependencies of `ilspycmd`, so don't remove it unless you're sure you don't need
to run it again.

The decompiled source doesn't have any comments, and some variables seem changed
from the original (e.g. `num1`, `num2`, `num3`, etc.) but it's mostly fairly
readable. The versions in `Source` do have comments, but the paths don't quite
match up (it seems many subdirs are lost in the decompile?) I considered copying
them over to `src` but I'm not sure if the code in `Source` matches the exact
version.

### Building the Assembly
"Assembly" is C♯ speak for any compiled output such as an executable (.exe) or
shared library (.dll). We need to set up a "build solution" (C♯ "Makefiles") to
build them. Let's start by just setting up a basic example before we start
actually writing code.

By convention the source code lives in `Mods/.../Source/`, but I don't think
this is required since the game doesn't *do* anything with it directly. The
resulting DLL files should be in `Mods/.../Assemblies/`. Note that you will use
a .dll file on Linux as well – it's just how Mono/C♯ on Linux works. They are
cross-platform, an assembly built on Linux should also work on Windows and
vice-versa. 

The game code lives in two namespaces: `Verse` and `RimWorld`. `Verse` is the
game engine and RimWorld is the game built on that. At least, I *think* that was
the intention at some point as all sort of RimWorld-specific things seem to be
in `Verse` (which also references the `RimWorld` namespace frequently) and there
isn't really a clear dividing line, but mostly: general "engine-y things" are in
`Verse` and "RimWorld-y things" are in `RimWorld`, except when they're not. 

In `Source/RainingBlood.cs` we'll add a simple example to log something to the
developer console:

{:class="ft-cs"}
    namespace RainingBlood {
        [Verse.StaticConstructorOnStartup]
        public static class RainingBlood {
            static RainingBlood() {
                Verse.Log.Message("Hello, world!");
            }
        }
    }

The `[Verse.StaticConstructorOnStartup]` annotation makes the code run when the game
starts. Basically, the game searches for all static constructors with this
annotation and startup and executes them. If you really want to know how it
works you can use something like `rg '[^\[]StaticConstructorOnStartup'`.

Another way is inheriting from the `Verse.Mod` class, which allows some more
advanced things (most notably [implementing settings][settings]), but I'm not
going to cover that here.

{% note %}
A lot of mods add `using Verse;` and `using RimWorld` so you can use
`StaticConstructorOnStartup` instead of `Verse.StaticConstructorOnStartup`. I've
never really liked this kind of implicit namespacing (in any language) and I'll
avoid it here too. It clarifies that `StaticConstructorOnStartup` is something
belonging to `Verse`, rather than being some built-in C♯ or .NET thing or
something. Maybe I'll change my mind later as I become more familiar with C♯ and
RimWorld, but certainly when learning I find it a lot easier to be explicit at
the expense of slightly more verbosity.
{% endnote %}

[settings]: https://rimworldwiki.com/wiki/Modding_Tutorials/ModSettings

To build this we'll need to set up a "build solution", which consists of a
.csproj XML file and a .sln file. This is something I mostly just copied and
modified from other projects; it seems that most people are auto-generating this
from Visual Studio or MonoDevelop, with little instructions on how to write
these things manually. There's probably a better way of doing some things (not a
huge fan of the hard-coded paths instead of using some LDPATH analogue), but I
haven't dived in to this yet.

Anyway, here's what I ended up with in `Mods/RainingBlood/RainingBlood.csproj`:

    <?xml version="1.0" encoding="utf-8"?>
    <Project ToolsVersion="14.0" DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">

        <Import
            Project="$(MSBuildExtensionsPath)/$(MSBuildToolsVersion)/Microsoft.Common.props"
            Condition="Exists('$(MSBuildExtensionsPath)/$(MSBuildToolsVersion)/Microsoft.Common.props')"
        />

        <PropertyGroup>
            <RootNamespace>RainingBlood</RootNamespace>
            <AssemblyName>RainingBlood</AssemblyName>
            <!-- You probably want to modify this GUID for your mod, as it's supposed to be unique.
                 This is also referenced in the .sln file.
                 My system has "uuidgen" to generate UUIDs. -->
            <ProjectGuid>{7196d15e-d480-441a-a2e0-87b9696dd38f}</ProjectGuid>

            <Configuration Condition=" '$(Configuration)' == '' ">Debug</Configuration>
            <Platform Condition=" '$(Platform)' == '' ">AnyCPU</Platform>
            <OutputType>Library</OutputType>
            <AppDesignerFolder>Properties</AppDesignerFolder>
            <TargetFrameworkVersion>v4.7.2</TargetFrameworkVersion>
            <FileAlignment>512</FileAlignment>
            <TargetFrameworkProfile />
        </PropertyGroup>

        <!-- Debug build -->
        <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|AnyCPU' ">
            <DebugSymbols>false</DebugSymbols>
            <DebugType>none</DebugType>
            <Optimize>false</Optimize>
            <OutputPath>Assemblies/</OutputPath>
            <DefineConstants>DEBUG;TRACE</DefineConstants>
            <ErrorReport>prompt</ErrorReport>
            <WarningLevel>4</WarningLevel>
            <UseVSHostingProcess>false</UseVSHostingProcess>
            <Prefer32Bit>false</Prefer32Bit>
        </PropertyGroup>
        <!-- Release build -->
        <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|AnyCPU' ">
            <DebugType>none</DebugType>
            <Optimize>true</Optimize>
            <OutputPath>Assemblies/</OutputPath>
            <DefineConstants>TRACE</DefineConstants>
            <ErrorReport>prompt</ErrorReport>
            <WarningLevel>3</WarningLevel>
            <Prefer32Bit>false</Prefer32Bit>
        </PropertyGroup>

        <!-- Dependencies -->
        <ItemGroup>
            <!-- The main game code (RimWorld and Verse) -->
            <Reference Include="Assembly-CSharp">
                <HintPath>../../RimWorldLinux_Data/Managed/Assembly-CSharp.dll</HintPath>
                <Private>False</Private>
            </Reference>

            <!-- C#/.NET stdlib -->
            <Reference Include="System" />
            <Reference Include="System.Core" />
            <Reference Include="System.Runtime.InteropServices.RuntimeInformation" />
            <Reference Include="System.Xml.Linq" />
            <Reference Include="System.Data.DataSetExtensions" />
            <Reference Include="Microsoft.CSharp" />
            <Reference Include="System.Data" />
            <Reference Include="System.Net.Http" />
            <Reference Include="System.Xml" />
        </ItemGroup>

        <!-- File list -->
        <ItemGroup>
            <Compile Include="Source/RainingBlood.cs" />
        </ItemGroup>

        <Import Project="$(MSBuildToolsPath)/Microsoft.CSharp.targets" />
    </Project>

And `Mods/RainingBlood/RainingBlood.sln`:

    Microsoft Visual Studio Solution File, Format Version 12.00
    # Visual Studio 15
    VisualStudioVersion = 15.0.27703.2035
    MinimumVisualStudioVersion = 10.0.40219.1
    Project("{57073194-e8b4-4a20-b60c-ee0e10947af0}") = "RainingBlood", "RainingBlood.csproj", "{7196d15e-d480-441a-a2e0-87b9696dd38f}"
    EndProject
    Global
        GlobalSection(SolutionConfigurationPlatforms) = preSolution
            Debug|Any CPU = Debug|Any CPU
            Release|Any CPU = Release|Any CPU
        EndGlobalSection
        GlobalSection(ProjectConfigurationPlatforms) = postSolution
            {7196d15e-d480-441a-a2e0-87b9696dd38f}.Debug|Any CPU.ActiveCfg = Debug|Any CPU
            {7196d15e-d480-441a-a2e0-87b9696dd38f}.Debug|Any CPU.Build.0 = Debug|Any CPU
            {7196d15e-d480-441a-a2e0-87b9696dd38f}.Release|Any CPU.ActiveCfg = Release|Any CPU
            {7196d15e-d480-441a-a2e0-87b9696dd38f}.Release|Any CPU.Build.0 = Release|Any CPU
        EndGlobalSection
        GlobalSection(SolutionProperties) = preSolution
            HideSolutionNode = FALSE
        EndGlobalSection
        GlobalSection(ExtensibilityGlobals) = postSolution
            SolutionGuid = {31005EA7-3F04-446F-80B2-016137708540}
        EndGlobalSection
    EndGlobal

To build it you'll need [msbuild], which is not included in the Standard Mono
installation. It does have `xbuild`, but that gives a deprecated warning
pointing towards msbuild. Maybe it works as well, but I didn't try it. Luckily
`msbuild` does seem commonly packaged, so I just installed it from there.

[msbuild]: https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild?view=vs-2019

I put the solution files in the project root; other people prefer to put it in
the `Source/` directory, but you'll need to modify some of the paths if you put
it there. To build it, simply run `msbuild` from the directory, or use `msbuild
Mods/RainingBlood` to specify a path. After this you should have
`Assemblies/RainingBlood.dll`.

After starting the game now and opening the developer console you should see
"Hello, world!" in there.

### Writing the code
Alrighty, now that all the plumbing is working we can actually start doing some
stuff. Let's see what grepping for `exposedThought` gives us:

{:class="ft-cli"}
    [~/rimworld/src]% rg exposedThought
    Verse/AI/Pawn_MindState.cs
    415: if (curWeatherLerped.exposedThought != null && !pawn.Position.Roofed(pawn.Map))
    417:     pawn.needs.mood.thoughts.memories.TryGainMemoryFast(curWeatherLerped.exposedThought);

    Verse/WeatherDef.cs
    35: public ThoughtDef exposedThought;

`Verse/AI/Pawn_MindState.cs` seems to be what we want, and reading through
`MindStateTick()` the logic seems straightforward enough:

{:class="ft-cs"}
    namespace Verse.AI {
        public class Pawn_MindState : IExposable {
            // [..]

            public void MindStateTick() {
                // [..]

                if (Find.TickManager.TicksGame % 123 == 0 &&
                    pawn.Spawned && pawn.RaceProps.IsFlesh && pawn.needs.mood != null
                ) {
                    TerrainDef terrain = pawn.Position.GetTerrain(pawn.Map);
                    if (terrain.traversedThought != null) {
                        pawn.needs.mood.thoughts.memories.TryGainMemoryFast(terrain.traversedThought);
                    }

                    WeatherDef curWeatherLerped = pawn.Map.weatherManager.CurWeatherLerped;
                    if (curWeatherLerped.exposedThought != null && !pawn.Position.Roofed(pawn.Map)) {
                        pawn.needs.mood.thoughts.memories.TryGainMemoryFast(curWeatherLerped.exposedThought);
                    }
                }

                // [..]
            }
        }
    }

So every 123rd "tick" it checks the terrain and weather and applies any mood
effects. Digging a bit deeper:

- The `Pawn` class describes a person or animal ("pawn") in the game; every Pawn
  has a MindState attached to it.

- On every "tick" it calls the MindStateTick() method on the attached MindState
  instsance as long as the pawn isn't dead (as well as a number of other
  things).

- One "tick" corresponds to 1/60th real second, which is 1.44 minutes in-game
  time. This is the game's Planck time: everything that happens will take at
  least 1.44 minutes in-game.

- There are also "rare ticks" (= 250 ticks = 4.15 real seconds = 6 hours
  in-game, or 1/4th of a day) and "long ticks" (= 1000 ticks = 33.33 real
  seconds = 1 day in-game) that you can hook in to various places.

- If you speed up the game then ticks are just emitted faster: 3× or 6×. So
  instead of emitting a tick once every 1/60th second it becomes once every
  1/180th second or 1/360th second.

You can find a bit more about this in `Verse/Tick*.cs`. It's not really needed
to know this for a simple mod like this, but it's useful to know if you want to
write actual real mods.

Anyway, so how to add our custom logic? Let's first add a new "thought" we want
to apply to `Defs/ThoughtDefs/RainingBlood.xml` we created earlier:

    <ThoughtDef>
        <defName>BloodCoveredCannibal</defName>
        <durationDays>0.1</durationDays>
        <stackLimit>1</stackLimit>
        <stages>
            <li>
                <label>blood covered</label>
                <description>Reigning in blood!</description>
                <baseMoodEffect>10</baseMoodEffect>
            </li>
        </stages>
    </ThoughtDef>

And in the `Defs/WeatherDefs/RainingBlood.xml` let's add some new fields next to
the `exposedThought` we already have:

	<modExtensions>
		<!-- Class, not class! -->
		<li Class="RainingBlood.WeatherDefExtension">
			<exposedThoughtCannibal>BloodCoveredCannibal</exposedThoughtCannibal>
		</li>
	</modExtensions>

The way the XML maps to C♯ code is that every entry in the XML file is expected
to be a field in the `*Def` class (inherits from `Verse.Def`), for example for
the existing `exposedThought` the `WeatherDef` class has:

{:class="ft-cs"}
    public ThoughtDef exposedThought;

If you were to just add `exposedThoughtCannibal` you'd get an error telling you
that `exposedThoughtCannibal` isn't a field in the class:

{:class="ft-NONE"}
    <exposedThoughtCannibal>[...] doesn't correspond to any field in in type WeatherDef

But RimWorld comes with the `modExtensions` field to extend Defs. In this case
we're adding it to an entire new Def, but you can also patch existing Defs with
XPath and `PatchOperationAddModExtension`.

You'll also need to add a new class inhereting from `Verse.DefModExtension`:

{:class="ft-cs"}
    namespace RainingBlood {
        public class WeatherDefExtension : Verse.DefModExtension {
            public RimWorld.ThoughtDef exposedThoughtCannibal;
        }
    }

The `Class` attribute in the XML links the XML fields to this class. The name
can be anything. We can get the value in C♯ with the `GetModExtension<T>()`
method on any Def class, where `T` is the type (class name) you want. For
example, `GetModExtension<WeatherDefExtension>()` in this case. By using the
type system multiple mods can attach their own extensions and not conflict.

### Using Harmony
To make this actually *do* something we need to hook in some code; RimWorld
itself doesn't really have a "mod system" for this, but we can use [Harmony].
Harmony is a C♯ library to patch existing code and can do a number of things,
but the most useful (and least error-prone) is to run code before or after a
method. In our case, we want to run code *after*
`Pawn_MindState.MindStateTick()` to apply the `exposedThoughtCannibal` thought.

[Harmony]: https://github.com/pardeike/HarmonyRimWorld

To use this we'll need to register it as a dependency in our `About/About.xml` file:

    <modDependencies>
        <li>
            <packageId>brrainz.harmony</packageId>
            <displayName>Harmony</displayName>
            <steamWorkshopUrl>steam://url/CommunityFilePage/2009463077</steamWorkshopUrl>
            <downloadUrl>https://github.com/pardeike/HarmonyRimWorld/releases/latest</downloadUrl>
        </li>
    </modDependencies>

We'll also have to add it to the `RainingBlood.csproj` file as a dependency
*before* the `Assembly-CSharp` dependency:

	<!-- Dependencies -->
	<ItemGroup>
        <!-- Harmony must be loaded first -->
        <Reference Include="0Harmony">
            <HintPath>../HarmonyRimWorld/Current/Assemblies/0Harmony.dll</HintPath>
            <Private>False</Private>
        </Reference> 

        <!-- The main game code (RimWorld and Verse) -->
        <Reference Include="Assembly-CSharp">
            <HintPath>../../RimWorldLinux_Data/Managed/Assembly-CSharp.dll</HintPath>
            <Private>False</Private>
        </Reference>

        [..]

{% warning %}
If you previously registered/loaded the game with the mod enabled you should at
this point start the game and make sure the Harmony mod is loaded in the mod
list. Because we added this dependency later it won't be loaded automatically
for us, and if you don't do this *before* actually using Harmony the game won't
even load the main menu, with many confusing unclear errors in the log. This
took me forever to figure out.

You can also add `brrainz.harmony` to `~/.config/unity3d/Ludeon Studios/RimWorld
by Ludeon Studios/Config/ModsConfig.xml` manually.
{% endwarning %}

{% warning %}
There are two versions of Harmony: 1 and 2. Harmony 1 is used as `Harmony.Foo`,
Harmony 2 as `HarmonyLib.Foo`. A lot of resources for RimWorld patching use
Harmony *1* and mixing the two is not going to end well. I recommend just using
the [official documentation][hdoc]; it's pretty good.

[hdoc]: (https://harmony.pardeike.net/articles/intro.html)
{% endwarning %}

Now we can use it to run some code after the `Pawn_MindState.MindStateTick()`
method:

{:class="ft-cs"}
    namespace RainingBlood {
        public class WeatherDefExtension : Verse.DefModExtension {
            public RimWorld.ThoughtDef exposedThoughtCannibal;
        }

        [Verse.StaticConstructorOnStartup]
        public static class Patch {
            static Patch() {
                // Get the method we want to patch.
                var m = typeof(Verse.AI.Pawn_MindState).GetMethod("MindStateTick");

                // Get the method we want to run after the original.
                var post = typeof(RainingBlood.Patch).GetMethod("PostMindStateTick",
                           System.Reflection.BindingFlags.Static|System.Reflection.BindingFlags.Public);

                // Patch stuff! The string passed to the Harmony constructor can be
                // anything, and can be used to identify/remove patches if need be.
                new HarmonyLib.Harmony("arp242.rainingblood").Patch(m,
                    postfix: new HarmonyLib.HarmonyMethod(post));
            }

            // The special __instance parameter has the original class instance
            // we're extending. This is based on the argument name.
            public static void PostMindStateTick(Verse.AI.Pawn_MindState __instance) {
                var pawn = __instance.pawn;

                // Same condition as MindStateTick, but inversed for early return.
                if (Verse.Find.TickManager.TicksGame % 123 != 0 ||
                    !pawn.Spawned || !pawn.RaceProps.IsFlesh || pawn.needs.mood == null)
                    return;

                // Is this pawn a cannibal? If not, then there's nothing to do. You
                // can also expand this by checking for the Ideology cannibalism
                // memes, but this just checks the "cannibalism" trait on colonists.
                if (!pawn.story.traits.HasTrait(RimWorld.TraitDefOf.Cannibal))
                    return;

                // Let's see if the current weather has our new exposedThoughtCannibal.
                var w = pawn.Map.weatherManager.CurWeatherLerped;
                if (!w.HasModExtension<WeatherDefExtension>())
                    return;
                var t = w.GetModExtension<WeatherDefExtension>().exposedThoughtCannibal;
                if (t == null)
                    return;

                // Remove any existing thought that was applied and apply our
                // cannibalistic thoughts.
                if (w.exposedThought != null)
                    pawn.needs.mood.thoughts.memories.RemoveMemoriesOfDef(w.exposedThought);
                pawn.needs.mood.thoughts.memories.TryGainMemoryFast(t);
            }
        }
    }

I use the "manual method" here as that's a bit easier to debug if you did
something wrong, but you can also use the annotations. Again, see the Harmony
documentation. One thing you need to watch out for is getting the
`BindingFlags.[..]` right. If you don't then the reflection library won't find
your method and it'll return `null`. See the [GetMethod()] documentation. This
part actually took me quite a bit to get working. Unfortunately RimWorld doesn't
have a REPL or console (AFAIK?) but you can use some printf-debugging with
`Verse.Log.Message($"{var}")` and the like.

[GetMethod()]: https://docs.microsoft.com/en-us/dotnet/api/system.type.getmethod?view=net-5.0

I'm not going to step through the rest of the code in more detail here; I think
most of it should be obvious. I mostly just found this be looking through
various code and some strategic grepping. You can test this by using the Debug
Actions menu, which allows assigning the Cannibalism trait to a colonist.

Next steps
----------
The above wasn't really all that useful as such, and there are many more parts
of RimWorld modding – most of which I haven't looked at in detail yet – but this
should at least give a decent base to get started with.

I have to say that I found a lot of documentation and guides on the topic to be
of, ehm, less-than-stellar quality :-/ The RimWorld wiki has a whole bunch of
pages, but – with a few exceptions linked in the article here – I found many are
unclear, outdated, or both, and in a few cases just downright wrong. Keep that
in mind if something doesn't work: usually it's a mistake to assume the
documentation is wrong instead of you, but here it might actually be the case.
I'll see if I'll write some more if I keep up interest in this.

Some additional reading for topics not covered:

- [Multi-version mods](https://docs.google.com/document/d/e/2PACX-1vSOOrF961tiBuNBIr8YpUvCWYScU-Wer3h3zaoMrw_jc8CCjMjlMzNCAfZZHTI2ibJ7iUZ9_CK45IhP/pub)

  Details how to make a mod compatible with both 1.2 and 1.3. I elided this for
  simplicity, and also because quite frankly I don't really care as I'm just
  interested in writing some mods that work for *me* to fix/improve some things 🤷

- [RimWorld art source](https://ludeon.com/forums/index.php?topic=2325.0)

  The original PSD files for all art in RimWorld. Useful if you want to use a
  modified version in your mod.

- [Mod folder structure](https://rimworldwiki.com/wiki/Modding_Tutorials/Mod_folder_structure)

  Covers some things not used in this example, such as sounds, textures, and
  i18n.

- [TDBug](https://github.com/alextd/RimWorld-TDBug) adds some debug things which
  seem useful. Haven't tried it yet.

### Missing parts
And some things I'd still like to improve/figure out:

- I would really really like a REPL, debugger, or some other way to speed up the
  dev cycle. RimWorld takes fairly long to start (almost a minute on my laptop)
  and toying around with things is kinda annoying and time-consuming.

  The closest I found is [How I got RimWorld debugging to work][dbg]; the CLI
  works on Linux (run with `dnSpy.Console.exe`, from the .NET download) but the
  GUI doesn't (and never will, as the Windows-specific GUI toolkit things aren't
  implemented on Linux), but this doesn't support the debugger (just
  decompilation).

  I tried the generic [sdb] Mono debugger, but the game doesn't load directly
  with Mono but rather via the 32M `UnityPlayer.so`, so using that seems
  difficult. Using [gdb] works, but actually doing useful stuff with it (i.e.
  breakpoints, calling functions, displaying variable values) seems harder, but
  I haven't spent that much time with it yet.

  [dbg]: https://fluffy-mods.github.io//2020/08/13/debugging-rimworld/
  [sdb]: https://github.com/mono/sdb
  [gdb]: https://www.mono-project.com/docs/debug+profile/debug/#debugging-with-gdb

  Making the game start faster would help too, or an automatic "script" to run
  on startup (i.e. to apply certain debug actions).

- On Linux the Assemblies are in `RimWorldLinux_Data/`, but on Windows and macOS
  this directory is `RimWorldWin64_Data/` and `RimWorldMac_Data/`. Right now the
  build solution builds just on Linux, but I'd like to be able to make it build
  on all systems.

  Hard-coding this path seems common; to get other mods to build I had to
  manually s/Win64/Linux/ some things, which is not ideal. I couldn't figure out
  how to make it cross-platform.

- There are probably some other C♯/.NET things that could be improved. I'm
  really a n00b at this.
