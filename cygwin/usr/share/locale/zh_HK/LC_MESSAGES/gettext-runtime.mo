Þ          ü   %   Ü      p  B   q  !  ´  ð  Ö  9   Ç  M        O  e   \  :   Â    ý    	     ª
     ¿
  *   Ð
  1   û
     -     <  "   Q  9   t  I   ®     ø          ¦     ¿     Ð     â     ñ       ¬    :   ½  4  ø  é  -  @     N   X     §  X   ´  1       ?  (  G     p       1        À     Ý     ì  $     =   '  N   e     ´     J     \     z               §     ´     	                                                              
                                                          -V, --version               output version information and exit
   -d, --domain=TEXTDOMAIN   retrieve translated message from TEXTDOMAIN
  -e                        enable expansion of some escape sequences
  -E                        (ignored for compatibility)
  -h, --help                display this help and exit
  -V, --version             display version information and exit
  [TEXTDOMAIN]              retrieve translated message from TEXTDOMAIN
  MSGID MSGID-PLURAL        translate MSGID (singular) / MSGID-PLURAL (plural)
  COUNT                     choose singular/plural form based on this value
   -d, --domain=TEXTDOMAIN   retrieve translated messages from TEXTDOMAIN
  -e                        enable expansion of some escape sequences
  -E                        (ignored for compatibility)
  -h, --help                display this help and exit
  -n                        suppress trailing newline
  -V, --version             display version information and exit
  [TEXTDOMAIN] MSGID        retrieve translated message corresponding
                            to MSGID from TEXTDOMAIN
   -h, --help                  display this help and exit
   -v, --variables             output the variables occurring in SHELL-FORMAT
 Bruno Haible Display native language translation of a textual message whose grammatical
form depends on a number.
 Display native language translation of a textual message.
 If the TEXTDOMAIN parameter is not given, the domain is determined from the
environment variable TEXTDOMAIN.  If the message catalog is not found in the
regular directory, another location can be specified with the environment
variable TEXTDOMAINDIR.
Standard search directory: %s
 In normal operation mode, standard input is copied to standard output,
with references to environment variables of the form $VARIABLE or ${VARIABLE}
being replaced with the corresponding values.  If a SHELL-FORMAT is given,
only those environment variables that are referenced in SHELL-FORMAT are
substituted; otherwise all environment variables references occurring in
standard input are substituted.
 Informative output:
 Operation mode:
 Report bugs to <bug-gnu-gettext@gnu.org>.
 Substitutes the values of environment variables.
 Ulrich Drepper Unknown system error Usage: %s [OPTION] [SHELL-FORMAT]
 Usage: %s [OPTION] [TEXTDOMAIN] MSGID MSGID-PLURAL COUNT
 Usage: %s [OPTION] [[TEXTDOMAIN] MSGID]
or:    %s [OPTION] -s [MSGID]...
 When --variables is used, standard input is ignored, and the output consists
of the environment variables that are referenced in SHELL-FORMAT, one per line.
 Written by %s.
 error while reading "%s" memory exhausted missing arguments standard input too many arguments write error Project-Id-Version: gettext-runtime 0.15-pre5
Report-Msgid-Bugs-To: bug-gnu-gettext@gnu.org
POT-Creation-Date: 2015-07-15 10:37+0900
PO-Revision-Date: 2006-07-05 17:16+0800
Last-Translator: Abel Cheung <abelcheung@gmail.com>
Language-Team: Chinese (Hong Kong) <community@linuxhall.org>
Language: zh_HK
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=1; plural=0;
   -V, --version               é¡¯ç¤ºçæ¬è³è¨ä¸¦çµæ
   -d, --domain=æå­é å     ç±<æå­é å>è®åç¿»è­¯å¾çè¨æ¯ã
  -e                        åè¨±å±éæé¡ escape sequence
  -E                        (çºäºç¸å®¹æ§å­å¨çé¸é ï¼ä¸æé æä»»ä½å½±é¿)
  -h, --help                é¡¯ç¤ºéæ®µèªªææå­ä¸¦çµæ
  -V, --version             é¡¯ç¤ºçæ¬è³è¨ä¸¦çµæ
  [æå­é å]                ç±<æå­é å>è®åç¿»è­¯è¨æ¯
  MSGID è¤æ¸MSGID           ç¿»è­¯ MSGID (å®æ¸) / è¤æ¸MSGID (è¤æ¸)
  æ¸å­                      æ ¹æ<æ¸å­>ä¾é¸æå®æ¸æè¤æ¸åæ
   -d, --domain=æå­é å     ç±<æå­é å>è®åç¿»è­¯å¾çè¨æ¯
  -e                        åè¨±å±éæé¡ escape sequence
  -E                        (çºäºç¸å®¹æ§å­å¨çé¸é ï¼ä¸æé æä»»ä½å½±é¿)
  -h, --help                é¡¯ç¤ºéæ®µèªªææå­ä¸¦çµæ
  -n                        å»é¤æ«ç«¯ç newline å­å
  -V, --version             é¡¯ç¤ºçæ¬è³è¨ä¸¦çµæ
  [æå­é å] MSGID          ç±<æå­é å>è®åç¸ææ¼ MSGID çç¿»è­¯è¨æ¯
   -h, --help                  é¡¯ç¤ºéæ®µèªªææå­ä¸¦çµæ
   -v, --variables             é¡¯ç¤º SHELL-FORMAT ä¸­åºç¾éçç°å¢è®æ¸
 Bruno Haible é¡¯ç¤ºææå­è¨æ¯çæ¬å°èªè¨ç¿»è­¯ï¼èç¿»è­¯çææ³åå®æ¸è¤æ¸å½±é¿ã
 é¡¯ç¤ºæåæå­è¨æ¯çæ¬å°èªè¨ç¿»è­¯ã
 åå¦æ²ææå®<æå­é å>åæ¸ï¼ç¨å¼ææ ¹æ TEXTDOMAIN ç°å¢è®æ¸ä¾è¨­å®æå­é åã
åå¦è¨æ¯è³ææªä¸å¨æ­£å¸¸çç®éä¸ï¼å¯ä»¥ç¨ç°å¢è®æ¸ TEXTDOMAINDIR æå®è¨æ¯è³ææª
çæå¨çä½ç½®ã
æ¨æºçæå°ç®éçºï¼%s
 å¨æ­£å¸¸æ¨¡å¼ä¸ï¼æå¾æ¨æºè¼¸å¥è®åè³æï¼ä¸¦å°å§å®¹ä¸­çç°å¢è®æ¸ (å $VARIABLE æ
${VARIABLE}) è½æçºè©²è®æ¸çå¼ï¼ä¸¦å¨æ¨æºè¼¸åºé¡¯ç¤ºçµæãå¦ææå®äº SHELL-FORMATï¼
ååªæ¿æ SHELL-FORMAT ä¸­æå®çè®æ¸ï¼å¦åææç°å¢è®æ¸é½ææ¿æã
 é¡¯ç¤ºè³è¨:
 æä½æ¨¡å¼:
 è«å <bug-gnu-gettext@gnu.org> å¯å ±é¯èª¤ã
 æ¿æç°å¢è®æ¸çå¼ã
 Ulrich Drepper ä¸æçç³»çµ±é¯èª¤ ç¨æ³ï¼%s [é¸é ] [SHELL-FORMAT]
 ç¨æ³ï¼%s [é¸é ] [æå­é å] MSGID è¤æ¸MSGID æ¸å­
 ç¨æ³ï¼%s [é¸é ] [[æå­é å] MSGID]
æï¼  %s [é¸é ] -s [MSGID]...
 å¦æä½¿ç¨ --variables é¸é ï¼å°ä¸æçæè¼¸å¥è³æï¼åªæè®å SHELL-FORMAT ä¸­ç
ç°å¢è®æ¸ä¸¦é¡¯ç¤ºè®æ¸åç¨±ï¼æ¯åä¸è¡ã
 ç± %s ç·¨å¯«ã
 è®åã%sãæåºç¾é¯èª¤ è¨æ¶é«èç¡ ç¼ºå°äºåæ¸ æ¨æºè¼¸å¥ åæ¸éå¤ å¯«å¥æç¼çé¯èª¤ 