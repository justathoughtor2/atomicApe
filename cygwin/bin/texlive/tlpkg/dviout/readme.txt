              dviout for Windows  Ver.3.18（Windows95/98/Me/NT/2000/XP）

                          January 15, 2006 by SHIMA

            (See 00readme.txt, install.txt, files.txt in English)

  dviout for Windows は、Windows95/98/Me および、WindowsNT/2000/XP用の TeX の 
device driver(Screen & Printer driver)です。

  従来のMS-DOS版の dviout/dviprt Ver.2.43.2 の機能を元にしております。

  以前の版からバージョンアップを行う際は、７.０ 以下の項を参照してください。


                     **********   目次    **********

     ０．Ver.3.10 以降の主要な拡張箇所
     １. 仕様
     ２. インストール
     ３. MS-DOS版との相違
     ４. 関連プログラム
     ５. アンインストール
     ６. サポート
     ７. Ver.3.0 以降からのバージョンアップ
     ８. 今後の改良と発展
     ９. Safe start
   １０. Windows NTでの問題点


０．           ***   Ver.3.10 以降の主要な拡張箇所  ***

・TeX -> TeX Help （Alt+H X）によるTeXの原稿作成補助機能で，エディタへの直接
  入力をサポート

・CID コード -> Unicode 変換を Adobe-Japan1-6 対応に

・\special{dviout `+<levels>} をサポート

以上は、Ver.3.18 における新規の機能です。


・TeX -> TeX Help （Alt+H X）によるTeXの原稿作成補助機能

以上は、Ver.3.17 における新規の機能です。


・CID コード -> Unicode 変換をサポート

・Continuous Renew 機能

・印刷ダイアログでのdviprt機能のカストマライズ

・グリッド線表示

・グラフィックエディタへのジャンプ機能

・指定した非対応specialsの無視機能

・矩形領域のPDF画像出力機能

以上は、Ver.3.16 における新規の機能です。


・subfonts 対応

・手の形のマースカーソルの時も Alt+F, Alt+J 等が有効

・パラメータファイルへのメニュー形式インタフェース
（Option → Choose Parameters,  ユーザが編集／追加可能）

・日本語フォント簡易変更機能（Option → Change Japanese fonts）

・プレゼンテーションモードでの、メニュー形式機能設定

・source specials で、マウスの左ボタンのダブルクリックに対応

・メニューバーのサブメニューに、割り当てキーを自動表示

・小ヒント集をヘルプメニューに追加（Help -> Tips on dviout -- 和文／欧文）

・color specials, tpic specials を使ったDVIファイルのページ独立性の修正

以上は、Ver.3.15 における新規の機能です。


・source special+文字列検索機能（エディタからpreview画面へのジャンプ）

・印刷ページ指定オプション（印刷ダイアログの [Option] ボタン）

・縦方向２頁同時表示／全頁連続スクロール機能

・プレゼンテーションモードでの線描画機能

・OpenType フォント対応

・CTRL+SHIFT+矢印キー による紙面の上下左右への微小位置補正

・EMF/BMP画像形式での矩形領域のクリップボードへのコピー

以上は、Ver.3.14 における新規の機能です。


・必要なフォント/画像ファイルの自動切り出しとDVIファイルへの埋めこみ

・初期設定のDVIファイルへの埋めこみ

・画面の切り出し画像出力

以上は、Ver.3.13 における新規の機能です。


・プロポーショナル和文TrueTypeフォント

・オンデマンド・フォント検索

・Virtual fonts 使用の際の高速化

・PSfrag対応

・min*, goth*, tmin*, tgoth*, jis, jisg, jis-v, jisg-v, newmin, newgoth の
  jfm ファイルのメトリック情報を dviout に内蔵。

以上は、Ver.3.12 における新規の機能です。


・任意のファイル（dviout が使う画像ファイル、パラメータファイル、フォントファ
  イルなどや他のプログラムのためのファイル）のDVIファイルへの埋め込み
  sample\sample.dvi がその例です。

・tar形式中のDVIファイルや画像ファイル、フォントファイルのサポート

・プレゼンテーション・モード
  sample\sli*.dvi がサンプルです。sample\sample.dvi の中からジャンプできます。
  新設された pause specials や dviout specials が役立ちます。

・キーマクロ

・dviout specials, pause specials
　sample\sample.dvi に解説があります。

・source specials および srctex, convedit
  source specials とは、DVIファイルの現在描いている場所が元のTeXファイルのどこ
　にあたるかの情報、すなわち元のファイル名と行番号の情報をDVIファイルに埋め込
  んだものです。
  これを使って、dviout と TeX ファイルのエディタとの間の相互ジャンプ機能が実現
  されます。
  MikTeX & yap でサポートされているものと互換です。

  TeXコンパイラを -help というパラメータで起動すると、そのTeXコンパイラが 
  source special をサポートしているかどうか分かります。たとえば

     platex -help

  としたとき、Option: として

    -src-specials          Insert source specials into the DVI file.
    -src-specials=WHERE    Insert source specials in certain places of
                           the DVI file. WHERE is a comma-separated value
                             list: cr display hbox math par parend vbox.

  という項があれば OK で、

    platex foo

  とする代わりに

    platex -src foo

  とすれば、各段落の冒頭に source specials の入った DVI が生成されます。
　source specials をサポートしたTeX コンパイラを用いなくても、付属の srctex で

    srctex platex foo

  とすることで対応されますが、できればサポートされたTeXコンパイラをお使いくだ
  さい。

  エディターとの交信手続きの設定については、Help の source specials の項を参照
　してください（目次 -> 概要 -> DVIファイルへの埋め込み ->source specials）。

・EMF(Enhanced Windows MetaFile)形式でのページ出力

・gzip で圧縮された画像ファイルやDVIファイルの取り込み
  それに伴い、dviout.def が更新されました。
  なおこの取り込みには gzip -d ... または gunzip ... が動作することが必要です。

・フォルダの履歴
  メニューバーからファイルを選ぶ時に、SHIFTキーを押していると、フォルダが開き
  ます。


１.                 **********   仕様   **********

・使用可能なTeX： 通常の欧文のTeX（含NTTJTeX）, アスキーの日本語pTeX, 
    Omega(-j), lambda(j)

・新機能: gray scale表示, ルーペ機能, 文字列サーチ機能, 文字列コピー機能,各機
    能およびマクロのキーへの自由な割り当て, 矩形領域のBMP/EMF/BMCやPDF/PNG/EPS
    などのファイル形式画像出力, フォントの所在の設定の推測機能, 任意のファイル
    のDVIファイルへの埋め込み, tar(+gzipped)形式ファイルのサポート, プレゼンテー
    ション・モード, 使用フォントや画像の必要データの抜き出しとそれのDVIファイへ
    の自動埋め込み（⇒ TeX環境なしで表示や印刷が可能）, グリッド線表示機能，グ
　　ラフィックエディターへのジャンプ機能

・拡張機能： tpic specials, PostScript specials, EPS/PS/WMF/EMF/PBM/BMP/BMC形
    式画像および PNG/JPEG/TIFF/PCD/PPMなど各種形式画像, およびそれをgzipで圧縮
    したファイルの取り込み, 文字列の色付け, 回転やスケール変換, \psflag, 
    PSfrag, HyperTeX specials, dviout specials, pause special, source special

・印刷機能： Windows95/98/Me/NT/2000/XP がサポートしているプリンタでの印刷
   （カラ ーに対応）やFAX送信、独自の内蔵プリンタドライバによる出力、および、
    dviout以外の印刷プログラムの制御機能の３種類の印刷方法をサポート。
    袋綴じ印刷, 縮小／拡大印刷機能, ページ指定マクロ

・欧文フォント, および, NTTJTeXの和文フォント： PK, PXL1001, PXL1002, PXL1003
    フォーマットのフォント, TrueTypeフォント, OpenTypeフォント
    PostScriptフォント
    Virtualフォント
    subfonts
    独自のPKDフォントディレクトリファイル
    Unicode
    METAFONTによる不足フォントの自動生成機能
    必要フォントや画像ファイルのDVIファイルへの自動埋めこみ機能

・フォントライブラリ： FARフォントライブラリ, GTHフォントライブラリ, FLIフォ
    ントライブラリ

・アスキーpTeX および NTTJTeX の和文フォント： JXL4フォント, ビットマップフォ
    ントおよびそれを独自の形式に圧縮したもの, 「書体倶楽部」形式のフォント, 
    Windows 3.1 や Windows95/98/Me/NT/2000/XP のTrueType和文フォント, 
    Virtualフォント

注意 1. PostScript画像を取り込むには, Ghostscriptが必要です。
     2. JPEG/TIFF/PCD/PPM など各種画像取り込に対応するには, Susie plug-in が
        必要です。
     3. PostScriptフォントを使うには, それに対応した mktexpk, gsftopk, dvipsk 
        および Ghostscript(gswin32c in PATH)が必要です.
     4. PNGなどの画像出力に対応するには、対応するABC出力プラグインが必要です。
     5. 矩形領域のPDF形式画像変換には，dvipdfmx 20040204以降が必要です。


２.                **********   インストール   **********

  プログラムとヘルプファイルをインストールします。それらは、同一ディレクトリ
（フォルダー）である限り、どこに入れてもかまいませんが、アンインストールや
バージョンアップを考慮すると、dviout用のディレクトリ（フォルダー）を作成し
て、そこに dviout for Windows と関連ファイルを入れておくとよいでしょう。
ただし、パス名に空白文字を含むようなディレクトリは、ほかのTeX関連のファイル
の場合と同様、避けたほうが無難でしょう。

  dviout for Windows のパッケージが d:\tex315w.zip であった場合は、コマンド
プロンプト（MS-DOS Window のプロンプト）から、たとえば以下のようにします。

  >mkdir \dviout
  >cd \dviout
  >unzip d:\tex315w

  このとき、\dviout に展開された dviout.exe と dviout.hlp, dviout.cnt のみ
が、dviout for Windows 側で最低限必要なファイルです。

  その他には、欧文のフォントファイル（PKフォント、またはWindowsに登録された
TrueTypeフォント + 対応するtfmファイル)が必要です。和文の文字には Windows の
TrueType和文フォントを使うことが出来ます。また、欧文フォントの自動生成機能
を使うには、-gen: を TeX のフォント生成機能に合わせて設定しますが、特殊な設
定が必要な場合はtemplateファイルで対応します（それのサンプルは、MakeTeXPK用
のものなどいくつかが utility\ に入っています）。

  最初に dviout.exe を起動すると、最低限必要な環境設定をするプログラムを実行
するかどうか、尋ねられます。通常の環境でプリンタ用の欧文PKフォントがディスク
にインストール済ならば、あるいは最近の標準的なTeXのシステムがインストールされ
ていれば（このときは、環境変数 TEXMFMAIN, TEXMFCNF が設定されているはず）この
初期設定プログラムを実行することにより、dviout が使用できる状態になります。
ただし、プリンタ（すなわちインストールしてある欧文PKフォント）の解像度（dpi）
を知っておく必要があります。

  初期設定プログラムで設定したパラメータは、後からいつでも変更可能です。
また、メニューバーから Option -> Install を選択すれば、初期設定プログラムを
再実行することもできます。

　初期設定プログラムを使いたくない場合は、以下のようにすることも可能です。

1. Option -> Setup Paremeters...-> Resolution で dpi: にその解像度(dots per
   inch)を設定し、更新(A) と Save を押す。

2. Font のシートに移動して、Guess ボタンを押す。フォントの検索の終了（最近の
   通常の環境が検知されれば，その設定を選べば OK）後、更新(A) と Save を押す。

  では、dviout.exe と dviout.hlp, dviout.cnt が、同一のディレクトリにあるこ
とを確かめ、dviout.exe を起動してみましょう（コマンドライン、あるいは、エク
スプローラなどからのマウスクリック）。

  メニューバーから

     Help -> Help Topics -> 目次 -> 目次 -> インストール

とたどっていけば、インストール（フォントの解像度とその所在、アイコン登録や
dviファイルのdvioutへの関連づけなどの設定）の説明が参照できます。

  そのほか、インストールの際やその後の疑問の点、dvioutの数多くの機能について
は、Help -> Help Topics -> 目次 の 概要 や Q&A などが参考になるでしょう。

   欧文フォントがインストール済みでなくて、mktexpk で自動作成していく場合は、
[Guess]でデフォルト設定を選択するか、あるいは、dvioutの起動の前に基本解像度の
cmr10 と lcircle10 のPKフォントのみを mktexpk で作成しておけば、初期設定プログ
ラムを利用できるでしょう。このときは、mktexpk の動かし方を、Option -> 
Setup Parameters -> Font2 -> gen: に登録します。通常は[gen:]ボタンで自動設定
されます。特殊な設定をする場合は、例えば、LIPS III 用のPKフォントを作成する設
定は、gen: に

   `mktexpk ^s ^d ^D ^M cx

などと書き、[Save]と[Ok]を押しておきます。なお、mktexpk にパスが通っていないと
きは、フルパス名で書きます（こちらを推奨で、[gen:]ボタンではそうなります）。

  Windowsに登録された欧文TrueTypeフォントを使用する場合は、Option -> 
Setup Paramaters -> Font -> TEXROOT: TEXPK: に対応する tfm ファイルの所在を
付け加えて、[Save]と[Ok]を押します。このとき対応する tfm ファイルは、^s.tfm
で表します。


３.           **********   MS-DOS版との相違   *********

  MS-DOS版では、プレビューを dviout が、印刷を dviprt が受け持ち、通常は両者
で異なる解像度のフォントを用意しました。dviout for Windows は、プレビューと印
刷の両方の機能を持っています。また、解像度の高い印刷用のフォントを、濃淡をつ
けて縮小して(gray scale, anti-aliasing)プレビューに用いることができます。

　たとえば、印刷用の 300dpi のフォントを 1/4 に縮小して 75dpi の gray scale 
で用いることにより、75dpi のフォントを準備して使った場合に比べ、より奇麗に表
示できます。高速な CPU を用い、メモリーも十分にあれば、600dpi 以上の印刷用
フォントをプレビューに用いても、速度低下は少ないと思います。

  インストール時に設定すべき最低限のパラメータは、dviout/dviprt の時の
-dpi と -TEXPK にあたるものです（-TEXPK: については、自動推測＋設定機能を
用いると便利です）。

  アスキーのpTeXのときの和文フォントは、デフォルトでは、Windowsの和文TrueType
（ＭＳ 明朝、ＭＳ ゴシック）が用いられます。

  そのほか、和文JGフォントは、利用者が少ないのと、機能が完全でない点があった
のでサポートをはずしました。


４.            **********   関連プログラム   **********

  dviout for Windows では WindowsAPIを使った印刷をサポートしていますが、コン
ソール版のdviprtやdvipsk などの外部プログラムによる印刷もコントロール可能です。
付属の rawprt.exe はプリンタへのリダイレクトにあたることを、Windowsのプログラ
ムとして安全に行うものです。

  propw は、Windowsで使用可能な和文(Proportional) TrueTypeフォントのjfmファイ
ルを生成するプログラムです。font\newjfm.txt や font\winttf.zip のドキュメント
を参照してください。具体的には、付属の propw.exe と pttfonts.map を使って

  > propw pttfonts.map

とすると、pttfonts.map のリストにある和文Proportional TrueTypeフォント（必要
なら表に追加すればよい）で Windows にインストールされているものの jfm ファイル
が作成されます。

  PostScriptで記述された画像データを PostScript specials によって取り込むには、
raw PBM、またはmonochrome BMP（カラー画像を扱うには、256色や1677万色などのカ
ラーBMP）出力をサポートした Ghostscript が必要です。

  PNG/JPEG/TIFF/PCD/PPM など各種画像に対応するには, Susie plug-in が必要です。
付属のbmc.exeはLaTeX2eのgraphics packageで画像サイズを知るための拡張子 .bb の
ファイルを作成する機能があります。

  HyperTeXによって dviout からインターネットにアクセスするには、WWW Browser が
必要です。WWW Browser（インターネットエクスプローラなど）と併用することにより、
インターネット上のdviファイルをプレビューすることもできます。

  インプレスの TeX for Windows で、dviout for Windows を用いることができます。
また、それ用に開発されたエディターなどの各種マクロなども使用できるでしょう。
詳しくは、Help -> Help Topics -> Q&A -> そのほか を参照してください。



５.            **********  アンインストール  **********

  dviout for Windows を起動して、Option -> Uninstall を実行すると、レジストリ
への dviout for Windows からの書き込みがすべて消去されます。その後、インスト
ールした dviout for Windows 関連のファイル（特定のディレクトリにまとめて入れて
おくとよい）をすべて削除します。

  dviout for Windows は、Windows やそのシステムディレクトリに（特に指定しな
い限り）、ファイルをインストールせず、そこにあるファイルを変更することはあり
ません。

  なお、他のインストーラつきのパッケージなどによって独自の方法でインストール
された場合は、この限りではありませんので、それに付属のドキュメントなどを参照
してください。



６.              **********  サポート  **********

  正式公開版は

  ftp://akagi.ms.u-tokyo.ac.jp/pub/TeX/dviout/

から、入手可能です。

  dviout for Windows のバージョンアップは、基本的には、dviout.exe, 
dviout(e).hlp, dviout(e).cnt を新しいものに置き換えるのみです（アンインストー
ルしてしまうと、設定が受け継がれませんので、ご注意ください）。それ以外に必要
なことがあれば readme.txt の ７ の項などに書かれています。付属のファイルが更
新されたり、追加される場合もあります。

  最新版およびそのソースファイル、あるいは、バグなどの情報は、以下から得るこ
とができます（1997年3月の時点）。

・ http://akagi.ms.u-tokyo.ac.jp/ftp-j.html#TeX
・ dviout User's 倶楽部（Mailing List [cf. Help -> Contents])

  バグなどの連絡先は

     dviout-admin@akagi.ms.u-tokyo.ac.jp

です。連絡いただいた mail は、差出人などが分かる部分を削除して、dviout User's 
倶楽部の Mailing List

     dviout@akagi.ms.u-tokyo.ac.jp

に転載する場合がありますので、ご了承下さい。ただしインストールなどに関する質
問を dviout-admin などの個人宛に頂いても、返事を出すことは困難なのでご了承く
ださい。このような質問は、dviout User's 倶楽部 にてお願いいたします。



７.     **********  Ver.3.0 以降からのバージョンアップ  **********

   Ver.3.0        March 14, 1997
        dviout for Windows の最初の正式公開版

以降に、新たに加わった主な機能は

・ dviprtのプリンタドライバを内蔵（特に、LIPS III/IV, ESC/Pageで高速)
・ カラー画像、カラー文字をサポート
・ LaTeX2e の graphics package を用いての dvips用に出力されたdviファイルに対応
・ フォントファイルの所在を推測し、設定する機能
・ Virtual fonts, 欧文TrueType fonts, OpenType fonts, subfonts に対応
・ オンデマンドフォント検索
・ Microsoft IntelliMouse（「まわるマウス」）に対応
・ プレビュー画面から文字列の取得（dvi2tty的な機能）
・ プレビュー画面から矩形領域を指定して画像出力（BMP, PNG, EMF etc.）
・ プレゼンテーションモード
・ source specials (dviout と editor との間での連携ジャンプ機能）
・ dviout specials による dviout の種々のコントロール
・ 使用フォントや画像，初期化パラメータなどをDVIファイルに取り込む機能
・ TeXの原稿作成補助機能

です。

  また、Ver.3.0 公開後発見され現在では修正されているバグは、history.txt に
書かれている

  186, 188, 192, 195, 203, 205, 208, 209, 211, 212, 213, 218, 220, 257, 258, 
  271, 273, 276, 299, 302, 311, 318, 320, 350, 383, 384, 395, 406, 589, 658

が主なものです。

７.０.１. Ver.3.15 または、それ以前の版からバージョンアップ
  -dviprt: が未定義の場合、印刷ダイアログで dviprtをチェックすると、dvipdfm(x)
による PDF ファイルへの変換がなされるようになった（従来は、コマンド版 dviprt 
による印刷が定義されていた）。従来の機能にするには、以下のように定義しておけば
よい。

-dviprt=echo^-O=^t^>>^^f;dviprt^-=^f^^q^^p;copy^^t^sprn^/b;del^^t^Zdviprt(default)

７.０.２. Ver.3.14 または、それ以前の版からバージョンアップ
  -ftt: で参照されるフォントマップファイルの添付版 ttfonts.map は、dviout.exe
の存在するディレクトリでなくて、そのサブディレクトリ map に置くのをデフォルト
にしました。dviout.exe にある *.map ファイルは削除してください（あるいは、必要
なら、サブディレクトリ map にコピー）。また、添付版への追加は map\$user.map へ
書くことを勧めます（今後のバージョンアップなどでも保たれる）。

７.０.３．Ver.3.12 より前の版からバージョンアップ
  フォントの検索をOn demandで行う（実際にそれを使う文字が現れるまで、検索しな
い）機能を追加し、そのがデフォルトになりました。従来通り起動時に検索するには、
[Font2] の OnDemand(Fod:) を OFF にしてください。

  GRAPHIC\latex2e\dviout.def が一部修正されましたので、古いものと入れ替えてく
ださい（最近のTeXでは、通常 %texmfmain%\tex\latex\config\ に置く）。

  和文フォントの文字サイズは、今まで高さを基準としていましたが、幅基準に変えま
した。通常使われている min*, jis*, rml や付属の長体・平体などでは、実際は従来
と結果が変わることはありません。


７.０.４．Ver.3.11 より前の版からのバージョンアップ
  Ver.3.10 に付属していた SAMPLE\ の中の sample.emf, *.wmc, *.bmp は不要なの
で削除できます。

  MS-DOS版 dviprt で使われていたプリンタ・コンフィギュレーションファイルとその
ソースファイルは、dviout for Windows の dviprt モードで標準でサポートしている
プリンタ以外の時のみ用いられるものですが、現在ほとんど使われていません。そのた
めこれらのファイル SRC\*.src, CFG\*.cfg は、prtcfg.zip, prtsrc.zip としてまと
めてパックし、ディレクトリ CFGに 入れました。このため SRC\*.src や CFG\*.cfg、
およびディレクトリ SRC は不要なので削除できます。

  HYPERTEX\myhyper.sty に正しくないところがあり、修正されましたので注意。

７.０.５. Ver.3.07 またはそれ以前の版からのバージョンアップ
  Windowsのprinter dviverを用いた（すなわち、印刷のダイアログで dviprt の項
のチェックを外した状態での）デフォルトの印刷方式が変わり、特に最近のプリンタ
を使ったTrueType fontsでの印刷が高速化されます。従来の方が高速であったり、う
まく印刷できない場合は、Option -> Setup Parameters -> [Graphic] の color 
specials の右側の項を auto mode(rep) に変更すると、従来の方法での印刷となり
ます。

７.０.６．Ver.3.06 またはそれ以前の版からのバージョンアップ

  dviprt 機能を使った LIPS III/LIPS IV による印刷機能で、紙面の上部の印刷不
可能領域を 5.3mm 程度減らしました。従って、これを用いていた場合、-TM: の設定
(Option -> Setup parameters... -> Printer Top)の設定値を 53 程度減らしてくだ
さい。印刷の位置を test_a4.dvi などを使って再調整してください。


７.０.７．Ver.3.06 より前の版からのバージョンアップ

  LaTeX2eのgraphic packagesでdviout用出力を指定している場合は、dviout.defを
このパッケージに付属のものに入れ替えてください（graphicx.sty の存在場所、た
とえば、$texmf\tex\latex\packages\graphics などに入っていることが多い）。


  Ver.3.02 より以前の版に上書きインストールした場合、以下の問題点の生じるこ
とがありますので、以下の各項を参照してください。


７.１. 文字列サーチで見つかった文字列に色が付かない。

  文字列サーチで見つかった文字列の色付け指定のデフォルト設定がうまくいってい
ない場合（Option -> Setup Parameters... -> Search で、Color: が box fill, 
white になっている場合）、Option -> Setup Parameters... -> Search で、
[Restore] を押すなどでして、好みの指定をして [Save] と、[更新] を押し、さらに、
[REGISTRY] のシートで、Search に + の印がついていることを確かめて、ここで再び
[Save] を押します）。


７.２. dviout.ini, dviout.vfn

  開発途中の版で使われていた dviout.ini, dviout.vfn は、不要となりました。
互換性のためこれらもサポートしていますが、混乱をさけるため、ファイル名を、
それぞれ dviout0.ini, dviout0.vfn としてあります（0 は、ゼロ）。

  dviout.ini (or dviout.par) が dviout のディレクトリ、あるいは、Windows の
ディレクトリに存在すれば、自動的にそれを読み込んでしまうので、注意してくだ
さい。


７.３. Ver.3.01a-8より前の版からのバージョンアップ

７.３.１. Ver.3.01a-8 または、それ以前の版からの Version UP

　Windows のドライバを用いて印刷を行っていた場合 Ver.3.01a-9 では、-LM: -RM:
の設定でなく、ドライバのデフォルトの位置補正の設定をデフォルトにしました。
従来の位置補正を有効にするには、Property Sheets -> [PRINTER] で、Use default
for the system driver のチェックをはずして、[Save], [OK]を押してください。
また、[REGISTRY] のプロパティーシートで（デフォルトで読み込むパラメータとして
-area: に + 印を付けて）、[Save] を押してください。

７.３.２. Ver.3.01a-1 または、それ以前の版からの Version UP

  -GIF: が、フラグ型パラメータから、整数型変数に変わりました。Postscript画
像のカラーの設定が、起動時のデフォルトにできないときは、[REGISTRY]のプロパ
ティーシートで（デフォルトで読み込むパラメータとして -GIF: に + 印を付けて）、
[Save] を押してください。[Graphic] のシートでGhostscriptの出力を256色BMPな
どと変更し、それをデフォルトとする場合にも、[Save] を忘れずに押してください。



８.          **********   今後の改良と発展   **********

  以下のようなものが考えられます。

  1. ユーザが外部ファイルで自由に specials を定義可能なマクロ言語
  2. GUIの改良、インストーラ
  3. DLL, OLE2などの導入
  4. HyperTeX によるマニュアル
  5. kpathsea のサポート

上記を含めて、今後とも有志のご協力をお願いいたします。


９.             **********   Safe start  **********

  dviout が基本的なパラメータなどの保存のために使用しているregistry（DISK上
のある領域）が、何らかの理由で破壊されてしまうと、dviout が正常に起動しなく
なる可能性があります。このような場合は、コマンドラインから

  dviout -NULL

として dviout を起動すると、registry からデータを読むこと無しに、dviout を起
動させることができます。この後、Option -> Setup parameters から、registry に
書かれたパラメータをチェック／検証したり、Option -> Uninstall で、dviout が
設定した全ての registry の書き込みを消去することができます。

なお、dviout.exe にパスが通っていないときは、コマンドラインに dviout.exe の
フルパス名を指定してください。


１０.       **********  Windpws NT での問題点  **********

  従来から Windows NT のTrueType和文フォントのサポートルーチン(API)にはバグ
がありましたが、それを dviout側で対処していました。サービスパック３のパッチ
をあてた状況では、より深刻なバグに発展したようで、縦書きの和文フォントを読
み出そうとすると、カーネルがフリーズするという深刻な事態が発生するという報
告を受けました。

  Windows API の GetGlyphOutline() 関数でフォントを読み出す際に、２行２列の
行列で文字の変形を行うことが出来ますが、淺山氏の調査によると これが単位行列
でないとシステムがフリーズしてしまうようです。デフォルトの縦書きフォントに
は対応しましたが、縦横のサイズ変更や斜体などを指定すると、このエラーが生じ
ると予想されます。

　和文のTrueType Fontの展開を、Windows NT のシステム側で行わずに、dvioutの
内蔵ルーチンに置き換えると、このエラーは起きません。具体的には、たとえば、
付属の dviout.vf0 を修正して、横書きの和文フォントは Windowsのシステムに任
せ、縦書きの和文フォントのみをdvioutの内蔵ルーチンに任せるように書き直して、
そのファイルをdvioutのProperty Sheetの [JFont2] の -vfn: に設定すれば OK で
す。

  なお、内蔵のTrueTypeフォント展開ルーチンでは、小さな文字の場合に品質が劣
るなどの欠点があります。また、松田氏の作成した ttindex.exe を用いて、DOS窓
などから

  >ttindex c:\windows\fonts\msmincho.ttf
  >ttindex c:\windows\fonts\msgothic.ttf

などのようにして、利用する和文TrueTypeフォントのインデックスファイルを作成
しておく必要があります。

  かなり深刻で致命的なバグでしたが、修正のパッチが公開されたようですので、
それを用いてください。
