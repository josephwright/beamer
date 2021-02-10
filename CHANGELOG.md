# Changelog
All notable changes to this project since v3.50 will be documented in this
file.

The format is based on [Keep a
Changelog](https://keepachangelog.com/en/1.0.0/), version strings comprise
a major and minor version only.

## [Unreleased]

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

[Unreleased]: https://github.com/josephwright/beamer/compare/v3.61...HEAD
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
