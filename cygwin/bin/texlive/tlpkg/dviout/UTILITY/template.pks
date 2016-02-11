#          GEN_FONT.BAT作成用テンプレート サンプル(for MakeTeXPK)
#                      By 八雲           1994/ 5/15
#		       modified by SHIMA 1996/12/27
#              	       modified by Otobe 1997/11/ 3
#
# auto=no
# extra_size=180
#
# Temporary batch-file name
# gen_tmp=gen_tmp.bat
#
#
# Batch-file name for ungenerated fonts
# gen_font=gen_font.bat
#
#
####  METAFONT \mode name definitions
#
# Atari 96x96 previewer
mode_name=96:atarins
#
# BBN Bitgraph at 118dpi
mode_name=118:bitgraph
#
# NEC PC-PR201 series
mode_name=160:nectzo
#
# Epson LQ-500, 180x180dpi
mode_name=180:lqlores
#
# 204 x 196  G3fax
mode_name=204:gtfax
#
# 204 x 196  G3fax landscape
mode_name=196:gtfaxl
#
# 200 x 200  G3FAX
mode_name=200:highfax
#
# Canon LBP-10
mode_name=240:canonlbp
#
# Canon CX, SX, LBP-LX, HP Laserjet(Plus), LaserWrite Plus, QMS 410
mode_name=300:CanonCX
#
# Epson Action Laser
#mode_name=300:epsonact
#
# NEC PC-PR406LM
mode_name=320:neclm
#
# Canon BubbleJet 10ex
mode_name=360:bjtenex
#
# NeXT 400dpi, Newgen
mode_name=400:nexthi
#
# Sun SPARCprinter
# mode_name=400:sparcptr
#
# CanonEX in LaserWriter Pro 630
mode_name=600:canonex
#
# HP LaserJet 4, QMS-860
#mode_name=600:ljfour
#
# Ultre*setter (1200dpi)
mode_name=1200:ultre
#
# Ultre*setter (2400dpi)
mode_name=2400:supre
#
%1st
%2nd
#
# ^s  METAFONT source file name (font name)
# ^d  font size ( dpi x magnification )
# ^D  dpi
# ^n  METAFONT mode name
#
MakeTeXPK ^s ^d ^D ^d/^D ^n
# mktexpk --dpi ^d --bdpi ^D --mag ^M --mfmode ^n ^s
%3rd
