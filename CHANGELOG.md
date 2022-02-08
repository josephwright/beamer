# Changelog
All notable changes to this project since v3.50 will be documented in this
file.

The format is based on [Keep a
Changelog](https://keepachangelog.com/en/1.0.0/), version strings comprise
a major and minor version only.

## [Unreleased]

## [v3.66]

### Fixed

- fixed edge case in numbering of hidden and unnumbered frames (see #756) 
- fixed regression of class options not being passed to packages like xcolor (see #759)

## [v3.65]

### Added

- adding new `onlytextwidth` class option to use this key for all `columns` environments by default (see #731)
- adding new stretchable frame option `s` (see #696)
- adding user-accessible commands for `\beamersidebarwidth` and `\beamerheadheight` (see #537)
- allow custom values for `aspectratio` option (see #549)

### Fixed

- using `gray` colormodel for the delcarartion of fadings (workaround for #718)
- fixed bullet colour of alerted items for custom item colour (see #735)
- workaround to make miniframes clickable in xelatex (see #332)
- added missing encoding value to multimedia sound macro (see #607)
- imporoved problem with shadow of blocks without title (see #647)
- reduced artefacts in poppler based viewers for shadow blocks (see #647)
- workaround to make `\framezoom` clickable in xelatex (see #619)
- exclude invisible frames from being counted (see #592)
- fixed cut off miniframes for 8pt and 9pt (see #752)

## [v3.64]

### Added

- new continuation count template "singleframecheck" which will only show the continuation count if a break actually occurs (see #423)
- new templated for lined note pages (#704)

### Changed

- added `aspectratio=2013` class option setting the frames' aspect ratio to 20:13 (see #497)
- Remove redefinition of `\addtocontents` (see #698)
- patched macros from the `pdfpages` package to automaticlly remove the frame background for the included pages
- transparent shadows for smoothbars outer theme (see #717)
- transparent shadows for smoothtree outer theme (see #720) 
- added new beamer option "show only slides with notes", the old class option "notes=onlyslideswithnotes" now gives an obsolete warning like all the other note options (see #724)
- make footnotetext and footnoterule adapt to the current column with (see #713)
- using `mathversion{sf}` for the kpfonts package (fix #711)

### Fixed

- solved font-dependant problem with shadow boxes (partial fix for #647)
- adding hook rule for polyglossia to compensate for the different execution order of the new hook system (see #706) 

## [v3.63]

### Changed

- adding `lastsection` option to toc (#675)

### Fixed

- Removed superflous period in combination with the `firstsection` option (#674)
- Behaviour of `\label` in article mode (#685)
- Problem with date position in infolines theme (#684)

## [v3.62]

### Fixed
- Issue with naming of file hooks (#670)
- fixed problem with `\insertmainframenumber` in combination with `ignorenonframetext` (see #665)

## [v3.61]

### Fixed

- `\beamer@bibiconwidth` already defined bug (see #652)
- shadowboxes and transparent overlays (see #654)
- workaround for misaligment of biblatex with sidebar theme (see #645)
- bug with nonshadow rounded boxed (see #660)

## [v3.60]

### Changed

- added translations for author, institute and date indicator of inmargin theme (see #616)
- re-introducing transparent shadows from v3.51 (see #492)

### Fixed

- Margins in frame title color box (see #614)
- adding font substitution (see #630)
- delaying fixes for biblatex styles until the bibliography (see #625)

## [v3.59]

### Changed

- added `\transfly` macro for `Fly` page transition (see #609)
- Preparations for LaTeX2e 2020-10-01

## [v3.58]

### Changed

- re-introduced `\strut` after the frametitle (see #535)
- Promote bookmark level for index (see #554)
- clip `\insertslideintonotes` to show only visible area
- using biblatex filehooks to make adjustments to the bibliography appearence (see #581)

### Fixed

- Avoid loop with overlayarea in vmode (issue #580)
- Handling of `\\` in article mode (issue #582)

## [v3.57]

### Changed

- More patch for `paralist` package (see #539)

### Fixed

- Replace `\mode` with `\only` (see #543)
- Reset the width of color box in case of change in `\hsize`

## [v3.56]

### Changed

- Improved parser for overlays

### Fixed

- Add missing commands with overlay specification (see #525)
- Replace fixed text width in `inmargin` theme (see #529)
- Treatment of `+` and `.` overlay specifiations (see #538)

## [v3.55]

### Fixed

- Inner behaviors for shaded ToC
- Fix optional arguments of `\frame` in `beamerarticle` (see #509)
- Compact glue settings for lists
- Turn off font substitution for `unicode-math` package (see #508)

## [v3.54]

### Changed

- Add the instructions of `proof begin` and `proof end` template
- Patch for `paralist` package

### Fixed

- Wrong frame number by `noframenumbering` option (see #450)
- Missing `nokeywords` option in the article mode
- Vertical glues by `allowframebreak` option (see #325)
- Typos and bad boxes in the documentation (see #491, #504 and #505)
- Revert the addition of `\input` and `\include`

## [v3.53]

### Fixed

- Behavior of `bg` key

## [v3.52]

### Fixed
- Behaviour of `\inst` (see #489)
- Incorrect shadows when using DVI routes (see #492)

## [v3.51]

### Changed
- Add `\include` and `\input` to commands respected in 'skipping' mode
- Dynamically calculate note page size (see #487)

### Fixed
- Properly set space in rounded boxes
- Enable transparency in shadows (see #466)
- Restore `\secname` in `\sectionentry`
- Apply color correctly to page number (see #468)
- Support for `noxcolor` with `beamerarticle` (see #483)
- Treatment of mixed overlay/alert specifications

[Unreleased]: https://github.com/josephwright/beamer/compare/v3.66...HEAD
[v3.66]: https://github.com/josephwright/beamer/compare/v3.65...v3.66
[v3.65]: https://github.com/josephwright/beamer/compare/v3.64...v3.65
[v3.64]: https://github.com/josephwright/beamer/compare/v3.63...v3.64
[v3.63]: https://github.com/josephwright/beamer/compare/v3.62...v3.63
[v3.62]: https://github.com/josephwright/beamer/compare/v3.61...v3.62
[v3.61]: https://github.com/josephwright/beamer/compare/v3.60...v3.61
[v3.60]: https://github.com/josephwright/beamer/compare/v3.59...v3.60
[v3.59]: https://github.com/josephwright/beamer/compare/v3.58...v3.59
[v3.58]: https://github.com/josephwright/beamer/compare/v3.57...v3.58
[v3.57]: https://github.com/josephwright/beamer/compare/v3.56...v3.57
[v3.56]: https://github.com/josephwright/beamer/compare/v3.55...v3.56
[v3.55]: https://github.com/josephwright/beamer/compare/v3.54...v3.55
[v3.54]: https://github.com/josephwright/beamer/compare/v3.53...v3.54
[v3.53]: https://github.com/josephwright/beamer/compare/v3.52...v3.53
[v3.52]: https://github.com/josephwright/beamer/compare/v3.51...v3.52
[v3.51]: https://github.com/josephwright/beamer/compare/v3.50...v3.51
