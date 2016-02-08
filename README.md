# atomicApe
## Always fresh. Always bananas.
Atom meets Babun in this repository optimized for running various forms of development software on a flash drive on Windows. Download one of the releases and unzip the folder *directly* to `MYDRIVELETTER:\` or run `cd MYDRIVELETTER:\ && git clone https://github.com/justathoughtor2/atomicApe.git`. Note that the reason the developer recommends using the flash drive directly is due to the Windows pathname character limit.

You may contact justathoughtor2 with any questions or comments at [atomicape@justathoughtor2.com](mailto:atomicape@justathoughtor2.com).

## Actually running the software
To start the atomicApe Babun terminal, double click on the file `babun.bat` in the root
directory of the unzipped folder. After starting the terminal, you may install new Cygwin packages with the command `pact install PACKAGENAME`.
You should test the command `pact` itself after installing atomicApe. If there are errors registered, run the command `fixbabun` and try again.
If all goes well, there will be no more errors in pact.

To start Atom, run the command `atom` from within the
Babun terminal. Note that this will occupy the terminal until you close Atom, so you might 
want to open another terminal with ALT+F2 (from within the first terminal). To run GCC, just
run `gcc` in the terminal. To run Python or pip, run either `python` or `pip`
(respectively). To run Node.js or NPM, run `node` or `npm` (respectively). To run Ruby or
RubyGems, run `ruby` or `gem` (respectively). To start UwAmp, run `uwamp`; this also
occupies the terminal for the duration of the software's run.

## Currently included software:
+ [Atom v1.4.3](https://atom.io/)
+ [Babun v1.2.0](https://github.com/babun/babun)
+ [Cygwin v2.4.1](https://cygwin.com/)
+ [GCC v4.9.3](https://gcc.gnu.org/)
+ [Python v2.7.10](https://www.python.org/)
+ [Pelican v3.6.3](http://blog.getpelican.com/)
+ [Ruby v2.2.4 and RubyGems v2.4.5.1](https://www.ruby-lang.org/en/)
+ [Jekyll v3.1.1](https://jekyllrb.com/)
+ [Node.js v4.2.6 and NPM v1.4.9](https://nodejs.org/en/)
+ [Forever v0.15.1](https://github.com/foreverjs/forever)
+ [Bower v1.7.6](https://github.com/bower/bower)
+ [UwAmp v3.0.2](http://www.uwamp.com/en/)
+ [Apache v2.4.10](http://www.apache.org/)
+ [MySQL v5.6.20](https://www.mysql.com/)
+ [PHP v5.4.31](https://secure.php.net/)
+ [phpMyAdmin v4.2.7.1](https://www.phpmyadmin.net/)