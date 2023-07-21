# TextMiningGUI

<details>

* Version: 0.3
* GitHub: NA
* Source code: https://github.com/cran/TextMiningGUI
* Date/Publication: 2021-04-17 16:20:02 UTC
* Number of recursive dependencies: 147

Run `revdepcheck::revdep_details(, "TextMiningGUI")` for more info

</details>

## In both

*   checking whether package ‘TextMiningGUI’ can be installed ... ERROR
    ```
    Installation failed.
    See ‘/Users/matthewjockers/Documents/syuzhet/revdep/checks.noindex/TextMiningGUI/new/TextMiningGUI.Rcheck/00install.out’ for details.
    ```

## Installation

### Devel

```
* installing *source* package ‘TextMiningGUI’ ...
** package ‘TextMiningGUI’ successfully unpacked and MD5 sums checked
** using staged installation
** R
** data
*** moving datasets to lazyload DB
** inst
** byte-compile and prepare package for lazy loading
Error: .onLoad failed in loadNamespace() for 'tcltk', details:
  call: dyn.load(file, DLLpath = DLLpath, ...)
  error: unable to load shared object '/Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/library/tcltk/libs/tcltk.so':
  dlopen(/Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/library/tcltk/libs/tcltk.so, 0x000A): Library not loaded: /opt/X11/lib/libX11.6.dylib
  Referenced from: <4B0D5E54-70B6-32B4-8FCA-74A7BF648428> /Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/library/tcltk/libs/tcltk.so
  Reason: tried: '/opt/X11/lib/libX11.6.dylib' (fat file, but missing compatible architecture (have 'i386,x86_64', need 'arm64')), '/System/Volumes/Preboot/Cryptexes/OS/opt/X11/lib/libX11.6.dylib' (no such file), '/opt/X11/lib/libX11.6.dylib' (fat file, but missing compatible architecture (have 'i386,x86_64', need 'arm64')), '/Library/Frameworks/R.framework/Resources/lib/libX11.6.dylib' (no such file), '/Library/Java/JavaVirtualMachines/jdk-17.0.1+12/Co
Execution halted
ERROR: lazy loading failed for package ‘TextMiningGUI’
* removing ‘/Users/matthewjockers/Documents/syuzhet/revdep/checks.noindex/TextMiningGUI/new/TextMiningGUI.Rcheck/TextMiningGUI’


```
### CRAN

```
* installing *source* package ‘TextMiningGUI’ ...
** package ‘TextMiningGUI’ successfully unpacked and MD5 sums checked
** using staged installation
** R
** data
*** moving datasets to lazyload DB
** inst
** byte-compile and prepare package for lazy loading
Error: .onLoad failed in loadNamespace() for 'tcltk', details:
  call: dyn.load(file, DLLpath = DLLpath, ...)
  error: unable to load shared object '/Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/library/tcltk/libs/tcltk.so':
  dlopen(/Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/library/tcltk/libs/tcltk.so, 0x000A): Library not loaded: /opt/X11/lib/libX11.6.dylib
  Referenced from: <4B0D5E54-70B6-32B4-8FCA-74A7BF648428> /Library/Frameworks/R.framework/Versions/4.2-arm64/Resources/library/tcltk/libs/tcltk.so
  Reason: tried: '/opt/X11/lib/libX11.6.dylib' (fat file, but missing compatible architecture (have 'i386,x86_64', need 'arm64')), '/System/Volumes/Preboot/Cryptexes/OS/opt/X11/lib/libX11.6.dylib' (no such file), '/opt/X11/lib/libX11.6.dylib' (fat file, but missing compatible architecture (have 'i386,x86_64', need 'arm64')), '/Library/Frameworks/R.framework/Resources/lib/libX11.6.dylib' (no such file), '/Library/Java/JavaVirtualMachines/jdk-17.0.1+12/Co
Execution halted
ERROR: lazy loading failed for package ‘TextMiningGUI’
* removing ‘/Users/matthewjockers/Documents/syuzhet/revdep/checks.noindex/TextMiningGUI/old/TextMiningGUI.Rcheck/TextMiningGUI’


```
