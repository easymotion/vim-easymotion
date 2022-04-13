function! EasyMotion#Chinese#load_dict()
    return {
		\ ' ' : '[ 　]',
		\ '!' : '[!！]',
		\ '"' : '["“”]',
		\ '#' : '[#＃№]',
		\ '$' : '[$¢£¤¥₩€￥]',
		\ '%' : '[%°‰‱℀℁℃℅℆℉⅍％]',
		\ '&' : '[&＆]',
		\ "'" : "[‘']",
		\ '*' : '[*·×※⁂☣☮☯❂・＊]',
		\ '+' : '[+＋]',
		\ ',' : '[，,]',
		\ '-' : '[-－]',
		\ '(' : '[（(]',
		\ ')' : '[）)]',
		\ '.' : '[.。]',
		\ '/' : '[/∕、／]',
		\ ':' : '[:：]',
		\ ';' : '[；;]',
		\ '<' : '[<«˂˱‹〈《]',
		\ '=' : '[=々＝〃]',
		\ '>' : '[>»˃˲›〉》]',
		\ '?' : '[?？]',
		\ '@' : '[@©®℗☯＠]',
		\ '[' : '[[「『【〔〖〘〚［]',
		\ '\' : '[、\＼＼]',
		\ ']' : '[]」』】〕〗〙〛］]',
		\ '^' : '[…^]',
		\ '_' : '[—_]',
		\ '`' : '[`′″‴‵‶‷⁗]',
		\ '{' : '[『〖｛]',
		\ '}' : '[』〗｝]',
		\ '|' : '[|¦§·‖・｜]',
		\ '~' : '[~˜˷∽≃≅≇≈≋≌⋍ⸯ﹋﹌﹏～]',
		\ 'a' : '[仰伌佁侒俺偣傲僾儑凒凹卬厂厑厫叆吖呵哀哎唉唵啀啊啽嗄嗌嗳嗷嗸嘊噫噯嚣坳垇垵埃埯堓塧墺壒夭奡奥奧娭娾婩媕媪媼嫒嫯嬡嬶安屵岇岙岰岸峖嶅嶴广庵廒愛慠懊懓懝抝拗按挨捱揞摮擙敖敱敳昂昹昻晻暗暧曖枊柪案桉梎欸毐氨洝溰溾滶澚澳濭熬爊爱犴獒獓玵瑷璈璦痷癌皑皚皧盎盦盫瞹矮砹硋碍磝礙罯翱翶翺聱肮胺腌腤艹艾芺荌菴萻葊蓭蔜蔼薆藹螯袄襖誝諳謷謸譪譺诶谙豻貋躷軪遨醠銨錌錒鎄鏊鏖鑀铵锕锿镺閊闇阨阿隌隘隞雸霭靄靉鞌鞍韽餲馣馤騃驁骜骯魞鮟鰲鱛鱜鱫鳌鴱鵪鶕鷔鹌黯鼇﨟]',
		\ 'b' : '[不丙並丷亳仈仌仢伯伴伻佈佊佖佨佰併侼便保俵俻俾倂倍倴偋偝偪偹傍備傡傧僃僠僰儐儤儦兡八兵冫冰別刨别剝剥办勃勏勹勽包匕北匾半卑博卜卞卟叐变叭吡吥吧呗咇咘哔哱哵哺唄啚啵嗶嘣嚗坂坌坒坝坢垪垹垻埄埔埗埠埲堛堡堢報塝塴墂壁壩备変夯夶夿奔奙奟奰妣妭妼姅婊婢媬嫑嬖孛孢孹宝宲宾寎寚寳寶屄屏岅岜峅峬崩嵭嶓巭巴币布帛帮幇幖幚幣幤幫并幷庇庍庯庰庳廍廦弁弊弝弻弼彃彆彪彬彼徧徶忁必忭怉怑怖怭怲怶悑悖悲惫惼愂愊愎愽憊憋懪扁扒扮扳扷抃把抜报抦抱拌拔拜拝拨挀挬挷捌捕捗捠捭捹掤掰揙揹揼搏搒搬摆摈摒摽撥撪播擘擯擺攽敗敝斃斌斑斒旁昁昄昞昪昺晡暴曓曝朇本朳朼杓杯杷板枹柀柄柈柏柨柭柲柸标栟栢栤桮桳梆梐梖梹棅棒棓椑椕楅楍榌榜槟標檗檦檳欂欛步歨歩殡殯比毕毖毙毞毴氷汳汴沘泊泌泍波泵浜浡淲淿渀渤湢湴溊滗滨滭滮潷濒濞濱濵濹瀌瀑瀕灞炞炦炮炳焙煏煲煸煿熚熛爂爆爸版牑牓牔牬犇犕犤犦狈狛狴狽猈猋猵猼獘獙獱玐玢玣玤玻珌珤班珼琣琫琲瑸璧璸瓝瓟瓣瓪瓸瓿甂甏甭甮畀畁畓畚畢疕疤疪病痭痹痺瘢瘪瘭癍癟癶癹白百皀皕盃盋眪睤睥矲砭砵碆碑碚碥碧磅磦礡礴祊禀禆禙秉秕秘秚秡稖稗稟稨穮窆窇窉竝竡笆笓笔笣笨笾筆筚箄箅箆箔箯篦篰篳簙簸簿籩粃粄粊粑粨粺糄糒糪紴絆絔絣綁綳綼緥編緶縍縪繃繴繽绊绑绠绷缏编缤缽罢罷罼羓翉耙聛肑肦胈胉背胞脖脿腷膀膊膑膘臂臏臕舨般舭舶艊艑艕芘芭苄苝苞苪苯苾茇荜荸荹莂菝菠菢菶萆萙萞萡萹葆葧蒡蓓蓖蓽蔀蔈蔔蔽蕃蕔薄薜薭藊藣藨藵蘗虌虣虨蚆蚌蚫蛂蛃蛯蛽蜌蜯蝂蝙螁螌螕蟞蠙补表袌袐被袯袹補裦裨裱褊褒褓褙褩褾襃襏襒襞襣襬襮覇覍觱詖詙誁誖誧諘諚謈謗謤譒變诐谤豍豝豩豳豹貏貝貱貶賁賓賔賲贁贆贔贝败贬贲赑趵跁跋跛跸踄踣蹕蹦蹩蹳躃躄軰軷輩轐辈辟辡辦辧辨辩辫辬辮辯边迊迸逋逩逬逼遍避邉邊邠邦邫邲邴邶郣郥部郶鄁鄙鄨鄪醭釆釟鈀鈈鈑鈨鈵鈸鈽鉋鉍鉑鉡鉢鉳鉼鋇鋍鋲錛錶錻鍽鎊鎛鎞鎺鏎鏢鏰鐴鐾鑌鑣鑤鑮钚钡钣钯钵钸钹铂铇铋锛镈镑镔镖镚镳閇閉閍閞閟闁闆闭阪陂陃陌陛雹霦霸靌靐靶靽鞁鞆鞕鞛鞞鞤鞭鞴鞸韛韠頒頻顮颁颮颰颷飆飇飈飊飑飙飚飶飹飽餅餑餔餠餢餺饆饱饼饽馎馛馝馞駁駂駜駮驆驋驫驳骉骠骲骳髀髆髉髌髕髟髩髱髲鬂鬓鬢魃魄魓魬鮁鮅鮊鮑鮩鯐鯾鯿鰏鱉鱍鲃鲅鲌鲍鲾鳊鳔鳖鳪鳵鳻鴇鴘鵏鵓鵖鵯鷝鷩鸔鸨鹁鹎麃鼈鼊鼥鼻齙龅龞]',
		\ 'c' : '[丑丒丛丞串丳乗乘乲亍产仇从仓仦仧仩仯仺伜传伡伥伧伬伺佌佽侈侘侙侟侧侪侱促俥俦俶倀倅倉倕倘倡倸偁偆偖偛偢偨偲側偿傖傗储傪催傳傸傺僘僝僢儃儊儏儔儕償儭儲儳充兏兹冁冊册冲凑凔凗処出刅刌刍创初刬刱刹刺刾剉剎剏剒剗剙創剶剷剿劖助勅勑勶匆匙卒单卶厂厕厝厠厨厰参參叄叅叉叢叱叺吃吜吵吹呈呎呲咤哧哾唇唓唱啋啐啛啜啻喍喘喫喰喳嗏嗔嗤嘃嘈嘗嘬嘲嘼噄噇噈噌嚐嚓嚫嚵嚽囅囆囪囱圌场坻坼垂垐垑垞埀埁城埕埫埰埱堘場堾塍塖塲塵墀墋墔墫壥处夎夦夨奼妛姹娍娕娖娼婃婇婥婵婼媋媨媰媸嫦嬋嬠嬦嬨存孮孱宠宬宷宸寀察寵寸尘尝尺层層屮岀岑岔峸崇崈崔嵖嵟嵢嵯嵳嵾嶆嶒巉巐巑巛川巢巣差帱常幝幢幨幬幮床庛庱廁廚廛廠弛弨彨彩彲彳彻徂徎従徔徖徜從徹忏忖忡忩忰忱怅怆怊怚怱怵恜恥恻悜悤悰悴悵惆惙惝惨惩惭惷惻愁愖愡愴愺慈慒慗慘慙慚慛憁憃憆憏憕憡憧憯憱憷懆懘懤懲懴懺成戳才扠扯扱承抄抶抻抽拆拵拺持挫挰挿捵捶掁採掣措掺插揣揨揰揷搀搊搋搐搓搥搽摌摏摐摚摛摧摲摴摻撐撑撡撤撦撮撺擉操擦攃攒攙攛攡敇敊敐敕敞敶斥斶斺旵旾昌春昶晁晨晿暙暢暰暷曟曹曺曾朁朝朾朿杈材村杘杵杶杻杽枞枨柌查柴査柽栕栦栨桘桭梣梴棇棌棎棖棦棰棽椆椉椎椘椙椽椿楂楚楤楮楱榇榋榱槆槌槎槯槽樄樅樔樗樘樬樷橁橕橙橱橻檉檙檚檫檮櫄櫉櫕櫥櫬欃欉欑次欩欪欻欼歂歜歠此歯殂残殘殠殦殩毚毳氅氚汆汊汌池沉沖沧泏泚泟洆测浐浱浺浾涌涔涰淐淙淬淳測湁湊湌湹湻溗滀滁滄滣滻漅漎漕漗漘漦漴漼潀潨潮潹潺澂澄澈澊澯澶濋濢濨濸瀍瀓瀺灇灛灻灿炊炒炽烢烥烾焠焣焯焻煁煘煼熜熶熾燀燦燽爘爜爞爡爨爯牀牊牎牕牚犉犓犨犫犲猖猜猝猠猭猹獊獑獕玔玚玼珁珫珵珹珿琗琛琤琩琮瑃瑏瑳瑺瑽璀璁璨璴瓷瓺瓻甆甞產産畅畜畴畻畼疀疇疢疩疮疵痤痴痸瘁瘄瘈瘎瘛瘡瘥瘯瘳癡皉皗皠皴盛眧眵睈睉睬睶瞅瞋瞛瞝瞠瞮矁矗矬砗础硛硟硨硩硶碀碜碴磁磋磛磢磣磪磭礎礠礤礸祠祡禅禇秅种秤称程稠稱穇穪穳穿窓窗窚窜窲窻窼竀竁竄竌竐竲竴竾笒笞笧筂策筞筬筴筹箎箠箣箺篅篘篡篨篪篵篸簅簇簎簒籌籿粋粗粚粣粲粹糍糙紁純紣紬絀絒絘絺絾綝綢綵綷綽緟緽緾縒縗縩縬繛繟繱纏纒纔纯绌绰绸缞缠罉罺罿羼翀翄翅翆翠翤翨耖耡耻聅聡聦聪聰肏肔肞肠胣胵脃脆脞脣脨脭脺腄腟腠腸膓膗膥膪膬膵臅臎臣臧臭臰臿舂舛舡舩舱船艖艙艚艟艬艸芆芻苁苂苌苍茈茌茐茝茞茦茨茬茶茺荈草荎荝荿莀莐莗莝莡莼莿菆菖菗菙菜萃萅萇萗萴萶葱蒇蒓蒢蒫蒭蒼蓌蓛蓯蓴蓸蔖蔟蔡蔥蔯蕆薋薒薵薼藂藏處虘虫虿蚇蚕蚩蚳蛏蛓蛼蜍蝅蝉蝩蝽螆螥螬螭螴螹蟌蟐蟬蟲蟵蟶蟾蠀蠆蠢蠶蠺衝衩衬袃袲袳裁裎裧裭裮裯裳褈褚褫褿襊襙襜襯覘觇觕觘触觸訍訦訬訵詞詧詫詶誎誗誠誯誴誺諂諃諔諶謓謘謥謲謿譂讇讎讐讒讖词诚诧谄谌谗谶豉豖豠豺貙財貾賗賜賝賨賩賰賶贂财赐赤赪赬赿趀趁趂超趎趗趠趡趣趩趻跐跴踀踆踌踔踟踧踩踳踸踹踿蹅蹉蹖蹙蹭蹰蹲蹴蹵蹿躇躊躔躕躥車軙輟輲輳輴轈车辍辏辝辞辤辭辰辵辶辿迟迠迡迧逞逪逴遄遅遚遟遪遫遲遳邨郕郴鄐鄛鄵鄽酁酂酢酧酫酬酲醇醋醕醜醝醦醻采重釧釵鈂鈔鉏鉓鉹銃銐銟銼鋋鋓鋤鋮鋹錘錝錞錩錯鍉鍖鍤鍯鎈鎚鏓鏙鏟鏦鏪鏿鐣鑔鑡鑱鑶鑹钏钗钞铖铛铲铳锄锉错锠锤锸镩镲镵長镸长閊閦閳閶闖闡闯阊阐阷陈陙除陲陳隀雌雏雔雛雠雦雴霃靗靫韂韔頙頳顀顇顣顫颤飡飭飺餈餐餟餷饓饞饬馇馋馳騁騘騬騲驂驄驓驰骋骖骢骣骴髊鬯魑魗鮆鮘鯎鯙鯧鰆鱨鲳鲿鴜鴟鵄鶉鶒鶞鶨鶬鶵鶿鷀鷐鷘鸧鸱鹑鹚鹺鹾麁麄麎麤麨麶黐黜黪黲鼀鼂鼌鼚鼜齒齓齔齝齣齪齭齹齼齿龀龊龡]',
		\ 'd' : '[丁东丟丢丹乧乭亣亶亸仃代仾伄伅伔佃但低侗侢俤倒倲偙偳傎傣僀働僜僤儅儋兊兌兑党兜兠典冬冻凋凍凙凟凳凼刀刁刂刐刟到刴剁剅剟剢剫剳动動勯匒匰匵单単厎厧厾叇叠叨叮叼叾吊吋吨吺呆呔呧呾咄咑咚咥哆哋哒哚唌唗唙唞啇啖啗啲啶啿喋喥單嗒嗲嘀嘚嘟嘾噉噔噠噵噸噹嚁嚉嚪嚲嚸囤地圵坔坘坫坻垈垌垖垛垜垤垫垯垱埅埊埞埬埭埵堆堕堞堤堵塅塔塠墊墑墩墪墬墮墯墱墶壂壋壔壿多夛大夺奃奌奝奠奪奲奵妉妒妬妲姛娣娻婝婰婸媂媅媏媠嫡嬁嬞嬻宕定对导対對導尮屌岛岱岻岽峌峒島崜崠崬嵣嵮嵽嵿嶋嶌嶝嶳嶹巅巓巔帄帎帒帝带帯帱帶幉庉底店度廗廸弔弟弤弴弹弾彈当彫彽待得徳德忉忊怛怟怠怼恎恫恴悳悼惇惦惪惮惰惵愓慸憚憜憝憞憺懂懛懟戙戜戥戴扂打扚扥扽抌抖抵担拞挅挆挏挕挡捣捯掂掇掉掋掸提揥揲搗搭摕撉撘撢撣撴擋擔擣攧攩敁敌敓敚敟敠敦敪敵斁斗斣断斷旦旳昳昸曃曡朵朶朷杕杜東枓枤柂柋柢柦柮栋桗档梊梑梪棏棟棣椗椟椡椣椯椴楪楯楴槇槙槝樀橂橷檔檤櫈櫝欓歹歺殆殚殜殫殬殰段殿毈毒毭毲氎氐氘氡氭氮氹汈汏沊沌沓沲泹洞浢涤涷淀淂淡渎渡湩滇滌滴潒潡澄澢澤澱澹濎濧瀆瀩瀻灙灯炖炟点焍焘煅燈燉燾爹牃牍牒牘牴犊犜犢狄狚独獃獤獨玎玓玬玳玷珰珶琔琱琽瑇瑖璒璗璫瓄瓙瓞瓭瓽甋甔甙电甸町畓畗畣畳當疂疉疊疍疔疸痘痥痽瘅瘨瘩瘹癉癚癜癫癲登的皾盄盗盜盪盯盹盾眈眔眣眰眱睇督睹瞊瞗瞪短石矴砀砃砘砥硐碇碉碓碘碟碠碫碭碲碷磓磴磸磹磾礅礑祋祶祷禂禘禫禱秪秺稲稻窎窞窦窵竇竨端竳笃笗笚笛笪第等答筜箪箽篤篼簖簜簞簟簤簦簹籪籴糴紞紿絰綐綞緞締緿縅繨繵纛绐绖缍缎缔羍羝翟翢翿耊耋耑耵耷耼耽聃聜聸肚胅胆胨胴脰腅腖腚腣腶膽臷舠舵艓艔艜艠艡艼芏苐苖苳苵荅荙荡荰荳荻菂菄菧菪菿萏萣董葮蒂蒧蓞蓧蔋蔐蔕蔸蕇蕩蕫薘薡薱藋藡蘯虭虰蚪蚮蛁蛋蜑蜔蜨蜳蝀蝃蝭蝳蝶螙螩螮螲蟷蟽蠧蠹衴袋袛裆裰裻褋褍褝褡褺襌襠襶覩覴覿觌觛觝訂訋詄詆詚誕読調諌諜諦譈譡譵讀讜讟订诋诞读调谍谛谠豄豆豋豴貂貣貸賧賭贉贕贷赌赕趃趆趓趤趸跌跕跢跥跮跶跺踮踱踲踶蹀蹈蹎蹛蹢蹬蹲蹾躂躉躖躭躱躲軃軇軑軚軧軩轛轪辺达迏迖迚迨迪迭迵逇递逓逗逮逹逿遁道達遞遯遰邓邸郖郸都鄧鄲酊酖酘醏釖釘釣釱鈄鈍鈟鈬鈿鉪銚銩銱鋽錖錞錠錭鍀鍍鍛鍴鎉鎝鏑鐓鐙鐜鐤鐸鐺鐽鑃鑟钉钓钝钭钿铎铛铞铤铥铫锝锭锻镀镝镦镫镻閗闍闘闣阇队阧阺阽陊陏陡陦陮隄隊隝隥隯雕電雼雿霘霮霴靆靛靪靮靯靼鞑鞮韃韇韣韥頂頓頔頕頧顁顚顛顶顿颠颩飣飿餖餤饏饤饳饾馰馾駧駳騳驐驔驮骀骶髑髢髧鬌鬥鬦鬪鬬鬭魛魡鮉鮗鯛鯟鯲鯳鰈鱽鲷鲽鳭鴏鴠鴩鴭鵆鵰鵽鶇鶎鶫鸐鸟鸫黕黛點黨黩黮黱黵黷鼎鼑鼕鼦齻龖龘﨣﨩]',
		\ 'e' : '[乻二仒佴侕俄偔僫儿児刵匎卾厄厑吪呃呝咡咢咹哦唲噁噩囮垩堊堨堮奀妸妿姶娥娿婀尒尓尔屙岋峉峎峏峨峩崿廅弍弐恩恶悪惡愕戹扼搤搹摁擜旕枙栭栮椧樲櫮欕欸歞毦洏洱涐湂煾爾珥珴琧皒睋砈砐砨硆磀礘粫而耏耳聏胹胺腭臑苊荋莪萼蒽蕚薾蚅蛯蛾蝁袻襨覨訛誀誐誒諤譌讍讹谔豟貮貳贰趰軛軶輀轜轭迗迩遌遏遻邇鄂鈋鈪鉺鋨鍔鑩铒锇锷閼阏阸阿陑隭鞥頋頞頟額顎颚额餌餓餩饵饿駬騀髵髶魤鮞鰐鰪鱷鲕鳄鴯鵈鵝鵞鶚鸸鹅鹗齃齶]',
		\ 'f' : '[丰乀乏仏付仮仹份仿伏伐伕佛佱俌俘俛俯俷俸倣偑偩偾傅傠僨僼冨冯冹凡凢凣凤凨凫凬凮分刜剕副勫匐匚匥匪厞反发吠否吩呋咈咐哹唪啡嘸噃坊坋坟坲坺坿垘垡堏堸堼墢墦墳夆复夫奉奋奜奮奿妃妇妋妚妢妦妨姂姇娐婏婓婔婦媍嬎嬏嬔孚孵富寷封尃屝岎岪峊峜峯峰崶巿帆帉帗幅幞幡幩府废廃廢弅弗弣彂彷彿復忛忿怤怫悱愤憣憤懯房扉払扶抚拂拊捬摓撫放敷斐斧方旉旊旙旛昉昐昘昲暃曊朆朌服朏杋杮枋枌枎枫枹柉柎柫栰栿桴桻梤梵棐棥棴棻棼椨椱楓榑榧樊橃橎橨檒櫠殕氛氟氾汎汸汾沣沨沷沸法泛泭洑浮浲涪淓淝渄渢湗溄滏滼漨澓濆濷瀪瀵瀿灃灋炃炥烦烰烽焚焤焨煈煩燌燓燔父牥犎犯狒猆猦獖玞玢玸珐琈琒琺璠瓬甫甶畈畉畐畨番疯疺疿痱瘋癁癈発發盕盙盽眆瞂瞓矾砆砜砝砩碸礬祓祔福禣秎秿稃稪竎竕符笩笰笲笵筏筟箙範篈篚簠籓籵粉粪粰糐糞紑紛紡紨紱紼絥綍綒綘緋緐緮縛縫繁繙纷纺绂绋绯缚缝缶缹缻罘罚罦罰罸翂翇翡翻肤肥肪肺胇胐胕脯腐腑腓腹膚膰膹舤舧舫艀艂艴芙芣芬芳芾苻茀范茯茷荂荴莩菔菲萉萯葍葑蒶蕃蕜蕟蕡蕧薠藅藩蘩蘴虙蚄蚠蚡蚥蚨蚹蛗蜂蜅蜉蜚蜰蝜蝠蝮蟦蠜蠭衭衯袚袝袢袱裶複褔襆襎襥覂覄覆訃訉訜訪詂誹諨諷讣讽访诽豐豧豮豶負販費賦賵賻负贩费赋赗赙赴趺趽跗踾蹯軓軬輔輹輻輽轒轓辅辐返逢邞邡郙郛鄜鄷酆酚酜酦釜釡釩鈁鈇鈖鉘鉜鋒鍅鍑鍢鎽鏠鐇鐨鐼钒钫锋镄閥阀阜阝防附陫隫雬雰霏靅靊非靟韍韨頫風颫颿飌风飛飜飝飞飯飰餥餴饙饭馚馡馥馩馮駙騑騛驸髣髪髮髴鬴魴魵鮄鮒鯡鰒鱕鱝鲂鲋鲱鲼鳆鳧鳬鳯鳳鳺鴀鴋鴌鴔鵩鶝鶭鷭麩麬麱麷麸黂黺黻黼鼖鼢鼣﨓]',
		\ 'g' : '[丐个丱串乖乢乫乬亀亘亙仠仡估伽佝佮佹侅侊供俇個倌倝傦僙僱光公共关冈冎冓冠冮凅凎凩凲刚刮刯刽刿剐剛剮割劀劊劌功勂勾匃匄匌匑匔匦匭卝卦厬厷叏古句叧叾各合吿呄告呙呱呷咕咖咣咯咶哏哥哽哿唂唃唝唟啂啒啩啯嗊嗝嗰嘎嘏嘓嘠噶囯囶固囻国圀國圪圭坩坬坸垓垙垝垢埂埚堈堌堝堩堽塥塨墎夃够夠夬夰夹奸妫姏姑姟姤姯姽媯媾嫢嫴嬀孤宄官宫宮家寡尕尜尬尲尳尴尶尷岗岡岣峐峺峼崓崗崞崮嶲工巩巪帰帼幊幗干幹广広庋庚庪廆廣廾弓彀彁彉彍归忋忓怪恑恠恭悹悺惃惈惯愅感愩愲慐慖慣懖戅戆戇戈戓戤戨扛扢拐拱拲挂挌挭掆掛掴掼揯搁搄搆搞搿摃摑摜摡摫撀撌擀擱攰攱改攻攼故敋敢旮旰昋晐晷暅暠更杆杚杛杠杲构果枴枸柑柜柧柺栝栱根格桂桄桧桰桿梏梗棍棝棡棺椁椝椢椩楇概榖榦榾槀槁槅構槓槔槨槩槪槶槹槻槼樌樻橄橭橰檊檜檺櫃櫊櫜櫷欟歄歌歸毂毌氿汞汩汵沟沽泒泔泴洸浭涡涫淈淉淦港湀溉溝滆滒滚滾漍漑漧潅澉澸濄濲瀔灌灨灮炅炔炗炚炛烡焵焹焿煱煹熕爟牨牫牯牿犅犵犷狗猓猤獦獷玍玕玽珖珙珪琯瑰璝璭瓂瓌瓘瓜甘畊畡疘疙疳痀痯痼瘑瘝癏癐癸皈皋皐皯皷皼盖盥盬盰睔睾瞆瞡瞶瞽矔矜矸矼硅硌碽磙礶祪祮祰祴祻祼禞禬秆稁稈稒稾稿穀窤竿笟笱笴筀筦筶筸筻箇箉箍箛管篐篙篝簂簋簳簼粓粿糓糕糼糿紺絓絚絠給絯綆綱綶緄緪緱緷緺縆縎縞红纥纲纶绀给绠绲缑缟缸罁罆罐罛罟罡罣罫羔羖羙羹耇耈耉耕耿聒聝肐肛肝股肱胍胱胳胿脵腂腘膈膏膕臌臦臩臯臵舘舸艮芉芥芶苟苦苷苽茖茛茥茪荄莄莞菇菒菓菮菰葛葢蒄蓇蓋蓕蓘蔉蔮薣藁藳蘬虢虼蚣蚼蛄蛊蛒蛤蛫蜾蝈螝蟈蟡蠱衦衮袞袧袼袿裓裹褁褂褠襘覌規覯観觀观规觏觚觡觤觥觵訽詁詌詬詭該詿誥諽謌謴诂诖诟诡该诰谷豥豿貢貫貴賅賌賡購贑贛贡购贯贵贾赅赓赣赶趏趕跟跪踻躀躬躮躳軈軌軱軲輁輄輠輥輨輵轂轕轧轨轱辊辜迀过逛逧過遘遦邽郂郌郜郠郭酐酤釓釭鈎鈛鈣鈲鈷鉤鉻銧銯鋯鋼錧錮錷鍋鎘鎠鎬鎶鎹鏆鐀鐹鑎鑵钆钙钢钩钴铬锅锆锢镉镐関閣閤閨闗關闺阁陒陔隑隔雇雊雚雟革鞈鞏鞲鞷鞼韐韚韝韟顧顾颈颪颳餜館餶餻饹馃馆馉馘騔騧騩骨骭骼骾高髙髸鬲鬶鬹鬼魀魐鮌鮕鮭鮯鯀鯁鯝鰥鱖鱞鱤鱥鱹鲑鲠鲧鲴鳏鳜鳡鳤鳱鴚鴣鴰鴿鶊鶻鷎鷱鸛鸪鸹鸽鹄鹒鹘鹳黆鼓鼔鼛龏龔龚龜龟嗀]',
		\ 'h' : '[乎乕乚乤互亥亨仜伙会佄何佪佫佷佸侯侴俒俰俿候倱偟傐傼僡儫儶兤兯冱凰函凾划剨劃劐劾化匢匫匯卉华厈厚号叿合后吓吙含吭吰吼吽呍呚呵呼咊和咍咟咳咴哄哈哏哕哗哠哬哻哼唅唝唤唬唿啈啝喉喊喐喖喙喚喛喝喤嗀嗃嗐嗥嗨嗬嘑嘒嘝嘩嘷嘿噅噑噕噺嚄嚆嚇嚎嚖嚛嚝嚯嚾嚿囘回囫囬圂圅圚圜坏垀垎垕垬垳垾埖堕堚堠堭塃塰墴壊壑壕壞壶壷壺夥夯夻奂奐奛奤奯好妅妎姀姡姮娂娢婎婚婟婫婲婳媈媓媩嫨嫭嫮嫿嬅嬒嬛孉孩宏宖宦害宺寉寏寒寣寭寰尡屶屷屸屽岵峆峘崋崡崲嵅嵈巟巷帍帿幌幑幠幻廆廻廽弖弘弧彋彗彙彚彟彠很徊後徨徻徽忶忽怀怘怙怳恆恍恏恒恗恚恛恢恨恵悍悎悔悙患惑惒惚惛惠惶愌感愰慁慌慧憓憨憾懐懳懷懽戏或戶户戸戽扈扖扞抇护抲拫拻挥捇捍换掍掝揈揘換揮搰搳摢摦撔撖撗撝撶撼擐擭攉攌敆斛斻旤旱昈昊昏昒昦昬晃晄晎晖晗晘晦晧暉暤暭暳暵曂曍曤曶曷會朚杭杹枑枠柇核桁桓桦桧梒梙棔椃椛楁楎楛楜楻楾榥槐槥槬槲槴槵横樺橞橫檅檓檴櫎櫘櫰欢欱歑歓歡殙毀毁毇毫毼氦汇汉汗汯汻沆沍沎沗沪河泋泓泘洃洄洉洪洹活浍浑浒浛浣浤浩浫海涆涣涥涵涸涽淏淮淴混渙渮渱渹渾湏湖湟湱溌溷滈滉滑滙滬滸滹漢漶漷潂潓潢潶澅澏澒澔澕澣澴濊濠濩瀈瀖瀚瀤瀫灏灝火灬灰灳灴炕炜炾烀烆烉烘烠烣烩烸焀焃焊焓焕焝焢煂煇煌煥煳煷熀熆熇熩熯熿燬燴燺爀爳犴犼犿狐狟狠狢猂猢猲猴猾獂獆獋獔獚獩獲獾玒玜环珩珲琀琥琿瑍瑚瑝璜璤璯環瓛瓠瓳甝画畫畵痐痕痪瘊瘓瘣癀癋癨皇皋皓皔皜皝皞皡皥皩皬盇盉盍盒眓眩睅睆睢睧睯睳睴睺瞺矆矐矦砉硔硡硴碋磆磺礉祜祸禈禍禾秏秮秳秴秽穔穢穫窢竑竓竤笏笐筕筨箶篁篊篌篕篲簄簧籇籺粐粠粭糀糇糊糫紅紇紘紦紭絎絗絙絵綄綋綔緩縠縨繢繣繪繯红纥纮绗绘缋缓缳罕羾翃翙翚翝翬翭翮翯翰翵翽耗耠耯耲耾聕肒肓肮胡胲胻脝膴臛舙航艎艧芐芔花芴苀苰苸茠茩茴荁荒荟荤荭荷莟获菏菡華萀萂萈萑葒葓葔葟葫葷蒦蒿蔊蔒蔛蔧蔰蕐蕙蕻薃薅薈薉薧薨藧藱藿蘅蘤蘳蘹蘾虍虎虖虝號虫虷虹虺虾蚘蚝蚢蚶蛔蛕蛤蛿蜖蜬蜭蝗蝴螒螖螛螜蟥蟪蠔蠖蠚行衡袆袔裄褐褘褢褱襅覈觟觨觳訇訌訶訸詤詥詪詯話詼誨誮諙諢諣諱諻謊謋謞謼譀譁譓譭譮護譹譿讙讧讳诃诙话诨诲谎谹谼谽谾豁豃豗豞豢豪豰豲貆貈貉貛貥貨賀賄货贺贿赫趪踝躵軣軤輝輷轋轘轟轰轷辉迒还迴逅逥逭遑遤還邗邩邯郃郇郈郝鄇鄗鄠酄酣酼醐醢釛釪釫釬鈜鈥鈨鉌鉷鉿銗銲銾鋎鋐鋘鋡錵錿鍃鍙鍠鍧鍭鍰鍸鎤鎺鏵鏸鐄鐬鐶鑅鑉鑊钬铧铪锪锽锾镐镬镮閄閈閎閡閧閽闀闂闔闠闤闬闳阂阍阓阖阛隍隓隳隺雇雈雐雗雘雽霍霐霟靃靍靎靏靧鞃鞎鞐鞨韄韓韩韹頀頇頏頜頮頶頷顄顥顪顸颃颌颒颔颢餀餄餛餬餭餯餱餲饚饸馄馠馯駭駴駻騜騞驊驩骅骇骸骺鬍鬟鬨魂魟魧魱魺魽鮜鮰鯇鯶鯸鰀鰉鰗鰚鰝鰰鰴鱑鱟鱩鱯鲄鲎鲑鲘鲩鳇鳠鳸鴅鴴鴻鵍鵠鶘鶡鶦鶮鶴鶾鷨鷬鸌鸖鸻鸿鹄鹕鹖鹘鹤鹮鹱麧麾黃黄黉黊黌黑黒鼲鼾齁齕龁龢]',
		\ 'j' : '[且丩丮丯丼举久乆九乣乩亅井亟交京亰亼亽仅今介仐件价伋伎伒伽佳佶佼侥侭侰侷俊俓俭俱俴倃倔倞借倢倦倨倶倹假偈健偮偼傋傑傕傢傹僅僒僟僥僦僬僭僵僸價儁儆儉儌儘兓兢其具兼兾冀冂冋冏军决冿净凈减凚几凥击刉刏刔刦刧刭刼剂剄剑剞剣剤剧剪剱剿劂劇劋劍劎劑劒劔加劤劫劲劵劼勁勌勣勥勦勬勮勼匊匓匛匞匠匶匷卙卩卪即卷卺卽厥厩厪及叚叝句叫叽吉君吤呁呌呟咀咎咭哜唊唧唫唶啹啾喈喞喼嗘嗟嗧嘂嘄嘉嘏嘦嘰噊噍噘噤噭噱嚌嚍嚼囏囝囧圈圾圿均坓坕坖坙坚坰垍埈埍埛埧基埾堅堇堦堲堺堻堿塂塉境墐墹墼壃壉壗夅夹夾奆奇奖奨奬奸奺妀妌妓妗姐姖姜姞姢姣姦姧姬姰娇娟娵婅婕婙婛婧婮婽媎媘媫嫁嫅嫉嫤嬌嬓嬧孂孑孒孓季宑家寂寄寋寖寠寯将將尐尖就尽局居屆届屐屦屨屩屫岊岌岕岠岨岬峤峧峻崌崛崨崫嵆嵇嵥嵴嵹嶕嶠嶡嶣嶥嶯嶻巀巈巠巨己巹巻巾帣帴幏幜幯幵幾庎庴廄廏廐廑廭建弆弜弡弪弳弶强弿彅彏彑彶径徑徛徣徤徦徺徼忌忣忦怇急恝悁悈悸惊惍惎惤惧愱愳慦慻憍憠憬憰憼憿懅懏懻懼戄戋戒戔戛戞戟戢戩截戬扃扴技抅抉抸拁拒拘拠拣拮挍挗挙挢挤挶挸捁捃捄捐捔捡据捲捷掎掘接掬掲掶揀揂揃揤揪揫揭搅搛搢搩摎摪摷摾撃撅撟撠撧撹撿擊擑據擠擧擮擶攈攟攪攫敎救教敫敬敽敿斍斚斝斠斤旌旍旔旡既旣旧昅昛晈晉晋晙景晶暕暞暨暩暻曁曒曔朘朞机朻杢杦杰极枃枅枧架枷枸柜柩柬柾校栫桀桊桔桕桝桨桱桷桾梘梜梞梮梷检棘棞椄椇椈椐椒検椵椷椾楐楖楗楫楬極楶楷榉榎榗榘榢榤槉槚槛槣槳槿樛樫樭橘橛橜機橶橸橿檋檕檝檞檟檢檵檻櫅櫤櫭櫸櫼欅欍欮歏歫歼殌殛殣殧殭殱殲毄毑毠毩毱毽氒氿江汣汫汬汮汲決沮泂泃泇泦泬泲泾洁洊洎洚津洰浃浄浅浆浇济浕浚浸浹浻涇涓涧涺淃淗淨済渐減湒湔湕湝湨湫溅溍滐滘滰漃漈漌漖漸漿潐潔潗澃澆澋澗澽激濅濈濜濟濬濺瀐瀞瀱瀳瀸瀽灍灚灸炅炬炯烄烬烱焆焌焏焗焦焳煍煎煚煛煡煯熞熦熲熸燇燛燼爑爝爴爵牋牞牮犄犋犌犍犑犗犟犱狊狙狡狤狷猄猏猳獍獎獗獥獧玃玑玖玠玦玨玪玾珈珏珒珓珔珺琎琚琻琾瑊瑐瑨瑴瑾璄璟璡璣璥璬璶璾瓹甲界畍畕畟畯畸畺畿疅疆疌疖疚疥疦疽疾痂痉痎痙痵瘕瘚瘠癠癤癪皆皍皎皦皭皲皸皹监盡監眗眷睊睑睛睠睫睷瞷瞼矍矜矝矡矩矫矯矶砄砎砛砠硷碅碊碣碱磯磵磼礀礁礆礍礓礛礷祭祲禁禝禨秔秬积秸稉稘稩稭稷稼稽穄穊積穖穚穧究穽窌窖窘窭窶竞竟竣竧竫竭競竸笄笅笈笕笳笺筊筋筓筠筥筧筴简箋箕箘箟箭箿節篯簊簡簥簴籍籛籧粔粳粷精糋糘糡糨糺系糾紀紒級紟紤紧絅経結絕絜絞絭絳絶絸絹經綗継綡綨緁緊緘緝縉縑績繋繘繝繭繮繳繼纠级纪经结给绛绝绞绢继绩缄缉缙缣缰缴罝罥罽羁羂羇羈羯翞翦耞耟耤耩耭聙聚聥肌肩肼胛胫胶脊脚脛脥脻腃腈腒腱腳腵膌膙膠膲臄臇臫臮臶臼舅舉舊舏舰艍艥艦艰艱艽节芥芨芰芵苣苴茄茍茎茤茧茭茮茳荆荊荐荕荚荠荩莒莖莙莢莭菁菅菊菌菤菨菫菺萛葁葌葏葪葭葰蒋蒟蒹蒺蓟蓳蓵蔇蔣蔨蔪蕀蕉蕑蕝蕨蕳蕺薊薑薦薺藆藉藎藠蘎蘏蘔蘜蘮蘻虀虃虠虡虮虳蚐蚗蚧蚷蛆蛟蛣蛱蛶蛺蜐蜛蜠蝍蝔螀螏螿蟜蟣蟨蟩蟭蟼蠒蠘蠞蠲蠽街衱衸衿袀袈袓袸袺裌裐裚裥裾褧褯襀襇襉襋襟襺覉覊見覐覚覠覬覲覵覸覺见觉觊觐角觔觖觙解觧觭觮觼訆計訐記訣詃詎詰誋誡誩誱諅諆諊諓諫謇講謭謯謹謽譎譏譑譛譤譥警譼譾讂计讥讦记讲讵诀诘诫谏谨谫谲谻豇豜豣豦豭貑貗貜賈賋賎賐賤賮賷贐贱贾赆赍赳赽趄趉趌趜趝趭趹趼跈跏跔跙距跡跤跲践跻跼跽踁踋踐踑踕踖踘踞踡踺踽蹇蹐蹟蹫蹴蹶蹷蹻躆躋躤躩躸躹軍輂較輯轇轎轚轞车轿较辑近进迥迦迳迹迼逈逕進遽邭郆郊郏郟郡郹鄄酒酱酵醤醬醮醵釂金釒釿鈌鈞鉀鉅鉣鉫鉴鉸銁銈銞銡鋏鋑鋦鋸鋻錈錤錦鍓鍕鍳鍵鍻鎅鎵鎸鏡鏩鏶鐍鐎鐖鐗鐝鐧鐫鐱鐻鑇鑑鑒鑙鑬鑯鑳钁钅钜钧钾铗铰锏锔锦锩键锯镌镓镜镢镹镼間閰间阄阙阱阶际降陖陱階際隮隽雃集雋雎雞雧霁霵霽靓靖静靚靜革靳鞂鞊鞠鞫鞬鞯鞿韀韁韉韭韮韲頚頡頬頰頵頸顈顜颉颊颎颶飓飢飷餃餋餕餞餰饉饑饥饯饺馂馑馢駃駉駏駒駕駫駶駿驕驚驥驧驹驾骄骏骥骱髻鬋鬏鬮鬾魕魝魢魥魪鮈鮔鮚鮫鮶鯚鯦鯨鯲鯽鰎鰔鰜鰶鰹鰿鱀鱂鱎鱭鱾鲒鲚鲛鲣鲪鲫鲸鳉鳒鳜鳩鳮鳽鴂鴃鴐鴡鴶鵁鵊鵋鵑鵔鵕鵘鵙鵛鵳鵴鶁鶄鶋鶏鶛鶪鶺鶼鷄鷑鷢鷦鷮鷲鸄鸠鸡鹃鹡鹣鹪鹫鹶鹸鹻鹼麂麇麉麏麔麕麖麚麠黅鼰鼱鼳齌齎齏齐齑齟齨齽龃龟龣﨔﨤]',
		\ 'k' : '[丂亏亢伉会佧侃侉侩俈倥偘傀儈儣克兡冚冦况凧凯凱凵凷刊刲刳刻剀剴剾劥劶劻勀勊勓勘匟匡匩匮匱匼卡厼口叩可吭呵咔咖咯咳咵哐哙哭啃喀喟喹喾嗑嘅嘳噲嚳囥困圐圦圹坎坑块坤坷垦垮垰垲埪堀堁堃堒堪塊塏墈墤墾壙壳壸壼夔夸夼奎奒妔姱娔媿嫝嬇嬶孔客宼宽寇寛寬尯尻岢岲岿峇崁崆崐崑嵁嵑嵙嵦嵪嵻嶱巋巙巜库庫康廓廤廥开彄归快忹忼忾怐恇恐恪恳恺悃悝悾惂愘愙愦愧愷愾慨慷憒懇懬懭戡戣扛扣扩抂抗抠拡括拷挄挎挳捆控掯揆揢揩搕摳摼擓擴攷敂敤旝旷昆昿晆晜暌暟曠枯柯栝栞栲框桍桛梡梱棵楏楑楛楷楿榼槛槺樖櫆欬欳欵款欿歀歁殨殻殼氪況洘洭浍涃涳渇渴溃溘滱漮潉潰澮濶濹炌炕炣烗烤焅焜煃熇熴爌牁牱牼犐犒犪犺狂狅狜狯猑獪珂琨瑻疴痾瘔盔看眍眖眶睏睽瞉瞌瞘瞰矌矙矻矿砊砍砢砿硁硄硍硛硜硱硻硿碦磈磕磡礊礚礦祵科秙稇稛稞穅穒穬空窛窟窠窥窺窽窾竷筈筐筘筷筺箜篑簆簣籄粇糠糩絋絖絝綑綛緙纊纩绔缂翗考聢聧聩聭聵肎肯肻胩胯脍膭膾臗舿艐芤苛苦莰菎萙萪萿葀葵蒅蒈蒉蒯蔲蔻蕢薖藈蘰蘷虁虧蚵蛞蜫蝌蝰衉衎袴裃裈裉裍裤裩褃褌褲誆誇誑誙課謉诓诳课豤貇貺贶趶趷跍跨跬蹞躨躻躾躿軖軠軦軭軻輆輡轗轲迲逵邝邟邼郀郐鄈鄶鄺酷醌醘釦鈧鈳鉱鉲銙銬銯銵鋛錁錓錕錹錺鍇鍞鍨鍷鎎鎧鎹鏗鏮鐦鑛鑧钪钶铐铠铿锎锞锟锴閊開閌閫閸闊闓闚闞闶闿阃阔阚阬隗霩靠鞚鞟鞹韕頍頢頦頯顆顑顝颏颗颽餽饋馈馗騉騍騤骒骙骷骻髁髋髖髛髠髡髨髺鬠鬫魁鮬鮳鯌鯑鯤鯳鰚鱇鱠鲓鲙鲲鵟鵥鵼鵾鶍鶎鶤鷇鹍黋龕龛]',
		\ 'l' : '[吕掠両两临丽乐乱亂亃了亮亷仂仑令伦伶佬來例侓侖侣侶俍俐俚俩俪俫倆倈倞倫倮倰偻傈傫僂僆僇僗僚僯儖儠儡儢儮儱儷儸儽兩六兰冧冷冽凉凌凓凛凜凩刕列刘刢利剆剌剓剹剺劆劉劙力劣励劳労劽勆勎勒勞勠勴勵匲匳卢卤卵历厉厘厤厯厲厸厽叓另叻吏吝呂呖呤咙咧咯咾哢哩哰哴哷唎唠唡唥唳唻啉啢啦啰啷喇喨喱喽嗠嗧嗹嘍嘞嘮嘹噒噜嚂嚕嚟嚠嚦嚧嚨嚹囄囇囉囒囖囵囹圇圙圝圞圥坜坴坽垃垄垅垆垏垒埌埒埓埨堎堜塁塄塛塯塱塶塷塿墚壈壘壚壟壠壢壣壨夌奁奩奱姈姥姴娄娈娌娳娽婁婈婡婨婪婯媡媹嫏嫘嫠嫪嫽嫾嬚嬼嬾孁孄孋孌孏孪孷孿寥寮寽尞尥尦屚屡屢履屪屴岚岦岭岺峈峍峛峢峦峲崀崂崃崊崍崘崙崚嵂嵐嵝嵧嵺嶁嶐嶗嶙嶚嶛嶺巁巃巄巒巤帘幱庐庲廇廉廊廔廖廘廩廪廫廬廲弄彔录彾律徕徠徿忇怜恅恋恡悋悡悢悧悷惀惏愣慄慩慮慺憀憐憥憦憭懍懒懔懢懰懶戀戮戾扐抡拉拎拢拦挒挔挘挛捋捛捞捩掄掕掚掳揦揧揽搂搚搮摙摝摞摟撂撈撛撩撸擂擄擥擸擼擽攂攊攋攎攏攔攞攣攦攬攭敛敹斂斄斏斓斕料斴斿旅旈旒旯昤昽晽晾暦暸暽曆曞曥曨曪曫朎朖朗朤朥朧朰朸李来林枥枦柃柆柳栁栃栊栌栎栏栗栛栳栵栾桞桹桺梁梇梠梨梸梾梿棂棃棆棙棱棶椂椋椤楋楝楞楼楽楿榁榄榈榔榴槞槤樂樃樆樏樐樑樓樚橉橊橑橮橯橹檁檑檩檪櫐櫑櫓櫔櫖櫚櫟櫣櫨櫪櫳櫴櫺欄欏欐欒欖欗欙欚欞欴歛歴歷殓殮氀氇氌氯氻沥沦沴泐泠泪泷泸泺洌洛洜洡流浌浏浖浨浪浰浶涖涙涝涞涟涼淋淕淚淥淩淪淶渌湅湰湸溂溇溓溜溣溧滝滤滥滦滷漉漊漋漏漓漣漤漯漻潋潞潦潾澇澑澛澜澟澧澪澰濂濑濓濫濼濾濿瀂瀏瀘瀝瀧瀨瀬瀮瀲瀶瀾灅灆灓灕灠灡灤灵炉炓炩炼烂烈烙烮烺焒焛煉煭熑熘熝熡熮燎燐燗燣燫燯燷爁爄爈爉爎爏爐爒爖爛爤爦爧牢犁犂犖犛犡犣狑狫狸狼猁猍猎猟猡獜獠獵獹玀率玈玏玲珋珑珕珞珯琅理琉琌琍琏琜琭琳瑓瑠瑬瑮瑯璃璉璐璘璙璢璷璼瓃瓅瓈瓎瓏瓐瓑瓓瓥瓴甅甊甐甪畄留略畧畱畾疁疄疗疠疬痢痨瘌瘘瘤瘰瘺瘻療癃癅癆癗癘癛癝癞癧癩癳癴癵皊皪盝盠盧盭眬睐睖睙睝睞睩瞜瞭瞵矋矑矓砅砬砱砳砺砻砾硉硌硓硠硦硫硵碄碌碐碖磂磊磏磖磟磠磥磮磱磷磿礌礧礨礪礫礰礱礲礼祣祾祿禄禮禲禷离秝秢稂稆稐稑稜稤穋穞穭穲窂窷窿竂竉立竛竜竰竻笠笭笼笿筙筣筤箂箓箖箩箻篓篢篥篭篮篱簍簏簓簕簝簩簬簵簶簾籁籃籙籚籟籠籢籣籨籬籮类粒粝粦粩粮粱粴粶粼糎糧糲糷累紷絡絫絽綟綠綸綹綾緉緑練縭縲縷縺繂繗繚繿纇纍纑纙纚纜纝纞纶练络绫绺绿缆缕缡缧缭罍罏罗罱罶罹羀羅羉羐羚羸翋翎翏翴翷老耂耒耢耣耧耬耮聆聊聋联聗聢聨聫聮聯聾肋胧胪脔脟脶脷脸脼腀腊腡膂膋膐膔膟膢膦膫臁臈臉臘臚臝臠臨舮舲舻艃艆艛艣艪艫良艻芦芲苈苓苙茏茘茢荔荖荦荲莅莉莨莱莲菈菉菕菞菱菻萊萙萝萰落葎葻蒌蒗蒚蒞蒥蓅蓈蓏蓝蓠蓢蓤蓮蓼蓾蔂蔆蔍蔞蔹蔺蔾蕌蕗蕶蕾薐薕藍藔藘藜藞藟藰藶藺藾蘆蘝蘞蘢蘦蘫蘭蘱蘲蘺蘽蘿虂虆虊虏虑虜蚸蛉蛎蛚蛠蜊蜋蜡蜦蜧蜽蝋蝲蝷蝼螂螊螰螺螻蟉蟍蟟蟧蟸蠃蠇蠊蠝蠟蠡蠣蠦蠪蠫蠬衑袊裂裏裗裡裢裣裬裲裸褛褳褴褵褸襕襝襤襰襱襴襽覝覧覶覼覽览觻詅詈詻誄誏諒論謢謧謰謱譋讄讈讕论诔谅谰豂豅豊貍賂賃賚賫賴賿贚赁赂赉赖赲趔趢跉跞路踉踚踛踜蹓蹗蹘蹥蹸蹽躏躐躒躘躙躝躪躮躴躵躶躼軁軂軨輅輌輘輛輪輬轆轑轔轠轢轣轤轥轮轳轹辂辆辌辘辚辢辣辽连迾連逦逨逯逻遛遱遴遼邋邌邏邐邻郎郒郘郞郦郲鄝鄰鄻酃酈酪酹醁醂醨醪醴醽里量釐釕釠鈩鈴鉝銇銠銮鋁鋃鋝鋢鋫鋰鋶錀錂錄錅錑錬録錴錸錺鍄鍊鎌鎏鎦鎯鏀鏈鏍鏐鏕鏤鏧鏫鏴鏻鐂鐐鐒鐪鐮鐳鑗鑘鑞鑢鑥鑨鑪鑭鑸鑼鑾钄钌铃铑铝铹铼链锂锊锍锒锣镂镏镙镠镣镥镧镭镰镴镽閊閖閝閬閭閵闌闾阆阑阞阾陆陇陋陯陵陸隆隣隴隶隷隸雒雡離雳零雷霊霖霗霛霝霤露霳靁靂靇靈靋靓鞡鞻韊韷領頛頪頱頼顂類顟顱顲颅领颣颲飀飂飅飉飗餎餾饠饹馏馿駖駠駱駵駺騄騋騮騼騾驎驑驘驡驢驪驴骆骊骝骡髅髎髏髗髝鬁鬎鬑鬛鬣鬲鬸魉魎魞魯魲魿鮤鮥鮱鯉鯏鯐鯠鯥鯩鯪鯬鯻鰊鰚鰡鰱鰳鱗鱧鱱鱲鱳鱸鱺鲁鲈鲡鲢鲤鲮鳓鳞鳢鳨鴒鴗鴷鴼鵅鵆鵉鵣鵦鵱鵹鶆鶹鷅鷚鷜鷯鷺鸁鸓鸕鸗鸝鸞鸬鸰鸾鹂鹠鹨鹩鹭鹵鹷鹿麍麐麓麗麜麟麢麳黎黧黸鼺齡齢龄龍龒龓龗龙郎凉裏隣礼]',
		\ 'm' : '[丆万丏乄么乜乮买亇亩亹仫们佅佲侎侔俛們偭傌僈僶儚免冃冇冐冒冕冖冡冥冪冺凂凕刡劘劢劰劺勄勉勐勔募勱匁卖卯厖厼吀吂名吗呒呣命咩咪哞哤哶唛唜喕喵嗎嗼嘛嘜嘧嘪嘿嚒嚜嚤嚰嚸囕圽坆坶垊埋堥堳塓塺塻墁墓墨売壾夘夢夣妈妙妹妺姄姆姥姳娏娨娩婂媄媌媒媔媚媢媺媽嫇嫚嫫嫲嫹嫼嬍嬤嬵嬷孊孖孟孭宀宓宻密寐寞尛尨屘岷峁峔峚崏嵄嵋帓帞帽幂幎幔幕幙幦幪幭庅庙庬庿廟弥弭彌徾忙忞忟怋怽恈恾悗悯悶惽愍愐愗慏慔慕慜慢慲憫懋懑懜懞懡懣懱懵戂戼扖扪抹抺抿拇挴捪捫掵掹描搣摩摱摸摹擝擟擵攗攠敃敉敏敯旀旄无旻旼明昧昩昴暋暓暝暪暮暯曚曼朙朦木末杗杣杧杩杪枆枚枺某柕栂梅梦梻棉椚椧楘楙楣楳榁榓榠榪槑槾樒樠模橅橗檬檰櫁櫋櫗欕歾歿殁母毎每毛毟毣毪毷氁氂氋民氓汅汒汨汶沐沒沔沕没沫沬沵泌泖泯洣洺浝浼淧淼渑渳渵渺渼湄湈湎湣満溕溟溤滅满滵滿漞漠漫漭潣澠澷濔濗濛瀎瀰灖灭炑烕焖焾煝煤熐熳燘燜爅爢牟牡牤牦牧牳牻犘犸狇狵猕猛猫猸猽獁獌獏獴獼玅玛玟玧玫珉珻琘琝瑁瑂瑉瑪璊瓕甍甿畂畆畒畝畞畮痗痝痲痳痻瘼癦皃皌皿盟目盲盳盿眀眄眇眉眊眛眜眠眯眳眸眽眿睂睌睦睰睸瞀瞄瞇瞐瞑瞒瞙瞞瞢矇矈矊矏矒矕矛码砇砞砪硥硭碈碼磨礞礣礳祃祕祙祢禖禡禰秒秘秣穆穈竗笀笢笷笽篃篎篾簚簢米粎糆糜糢糸絈綿緍緜緡緢緬緲縵縸縻繆纆绵缅缈缗缦缪罞罠罵羃羋美羙耄耱胟脄脈脉脒脢腜腼膜臱艋艒艨芇芈芒芼苗苜苠苺茂茅茆茉茗茫茻荬莈莓莔莫莯莽莾菛萌萺葂葞葿蒅蒙蒾蓂蓦蓩蔄蔑蔓蔝蔤蔴蕄蕒薎薶藌藐藦蘉蘑蘪蘼虋虻蚂蚞蛑蛖蛨蛮蜜蜢蝐蝒蝞蝥蝱螞螟螨蟆蟇蟊蟎蟒蟔蠎蠓蠛蠠蠻衊袂袜袤袮裃襔覒覓覔覛覭觅詸詺謀謎謐謨謩謬謾谋谜谟谧谩谬貃貊貌貓貘買貿賣贸跊踇踎軞迈迷邁邈邙郿鄍鄚鄤鄮鄳鄸酕酛酩酶醚醾醿釄釯鈱鉚鉧鉬鉾銆銘銤鋂鋩錉錨錳鍆鍪鍲鎂鎇鎷鏋鏌鏝鑖钔钼铆铓铭锚锰镁镅镆镘镾門閁閅閔閩门闵闷闽陌雮霂霉霡霢霥霾霿靀靡面靣靦靺鞔鞪韎顢顭颟饃饅饛饝馍馒馬駡駹驀马骂髍髦髳鬕鬗鬘鬽魅魔魩魸魹鮲鮸鯍鯭鰢鰵鰻鱴鳗鳘鳴鴓鴖鴾鶓鶜鶥鷌鷶鸍鸏鸣鹋鹛鹲麊麋麛麥麦麪麫麰麵麺麻麼麽麿默黙黣黴黽黾鼆鼏鼡]',
		\ 'n' : '[女疟丆乃乜乪乸伮伱伲佞你佴侫侬侽倪倷倿傉傩儂儗儜儞儺儾兒內内农凝凪努匁匘匿卄南吶呐呢呶咛哖哛哝哪唸啮喃喏嗫嗱噛噥噺嚀嚙嚢囁囊囓囔囜囝囡圼坭垴埝埿堄堖夒奈奴奶奻妞妠妮妳姩娘娚娜娞婗婻嫋嫐嫟嫩嫰嬝嬢嬣嬭嬲嬺孃孥孬孴孻孼孽宁寍寕寗寜寧尼尿屔屰峱嵲嶩嶭嶷巎巕帇年廼廿弄弩念忸怒怓怩恁恧恼您悩惄惗惱愞愵憹懦懧戁扭抐抩抳拈拏拗拟拧拰拼拿挊挠挪挵捏捺捻掜掿揇揑搙搦搻摰撓撚撵擃擬擰攆攮敜旎昵晲暔暖暱曩朒杻枏枿柅柟柠柰梛棿楠楾榒槈槷樢橠橣檂檷檸檽櫱欁欜氖氝氞氼汼沑泞泥浓涅涊淖淣淰渜渿湳湼溺澝濃濘灢炄焾煗煵燶牛牜狃狔狞猊猱獰獳獶獿瑙甯男畘疒疓痆癑眤眲睨矃砮硇碙碯碾禯秊秜秥秾稬穠穤笝笯篞簐籋籹籾粘糑糥糯糱糵納紐縇縌繷纳纽羺耐耨聂聍聣聶聹聻肭胒胬能脌脑脓脮脲脳腇腉腦腩腻膩膿臑臡臬臲艌艿苧苨苶茑莥莮莻菍萘萳蒳蔦蔫蕽薴薿蘖虐蚭蛲蜺蝻螚蟯蠥蠰衂衄衲袅袦裊褦褭襛觬訥詉誽諵諾譊譨讘讷诺豽貀貎赧跜踂踗踙蹃蹍蹑蹨躎躡軜輗輦辇辗農辳迺逆逽遖那郍郳酿醲醸釀釢釹鈉鈕鈮錗錜錼鍩鎒鎳鎿鐃鐞鑈鑏鑷钀钕钠钮铌铙锘镊镍镎閙闑闹陧隉隬难難雫霓靵靹音顳颞餒餪饢馁馕馜駑驽鬞鬡鬧魶魸鮎鮾鯑鯘鯢鯰鲇鲵鲶鳥鳰鸋鸟麑黁黏鼐鼡齈齉齧齯秊]',
		\ 'o' : '[丆乯仒偶区吘呕哦嘔噢塸怄慪旕櫙欧歐殴毆沤浌漚熰猠瓯甌硛穒筽縅縇纐耦腢膒蕅藕藲謳讴迲鏂鳰鴎鷗鸥]',
		\ 'p' : '[丕丬丿乒乓乶仆仳仿伂伓伴伾佩便俖俜俳倗偏傰僄僕僻冯冸凭凴判刨剖剻剽劈勡匉匍匏匹厐叛叭叵吡否呠呯呸咅咆品哌哛哣啤啪喯喷喸嗙嘌嘙嘭噗噴噼噽嚩嚬嚭囨圃圑圤圮坡坢坪坯垉垺埔埤培堋堡塀塜塳墣壀奅妑姘姵娉娝娦婄婆媥媲媻嫎嫓嫔嫖嫳嬪尀屁屏屛岥岯岶岼崥嶏巬巼帊帔帕帡帲幈幋平庀庖庞廹弸彭彯彷徘徬徱怌怕怦恲悂慓慿憉憑憵扁扑扒扳批抔抙抛抨抪披抷拋拌拍拚拼捀捊捧掊排掱掽揊搒搫撆撇撲擈擗攀攴攵敀斾旁旆旇旚昢普暜暴暼曝朋朩朴杷枇枈枰柈桲梈棑棚椑椖椪楄楩榀槃槰樥樸檏檘櫇歕殍毗毘毰氆氕汃汖沛沜沠泊泙泡泮泼洀洦洴派浦浿涄淎淜淠渒湃湐湓溥溿滂漂漰潎潑潖潘潽澎澼濆濮瀊瀑炇炋炍炐炮炰烞烳烹焩焷熢爬爮爿片牉牌牝犃犏犥犻狉狍狓猅獛玭玶珀珮琕琵琶璞瓢瓫瓶甁甓甹畔番疈疱疲痞痡癖皅皏皤皫皮皰盆盘盤盼眅眫睥瞟瞥瞨矉砏砒砯砰砲破砶硑硼碰磅磇磐磞磻礔礕礗礟礮票秛秠稝稫穙穦竮竼笸筢箁箄箥箳篇篣篷篺篻簈簰簲粕紕縏縹繁纀纄纰缏缥缾罴羆翍翩翲翸耙耚耪聘聠肧肨肶胓胖胚胮胼脬脯脴脾腁腗膀膍膖膨舖舗舥般舽艵芃芘苉苤苩苹荓莆莑莩菐菩萍萠萢葐葡葩蒎蒪蒰蒱蒲蓜蓬蓱蔢薲薸蘋蘕蚍蚲蚽蚾蛢蜱螃螵螷蟚蟛蟠蠯衃袌袍袙袢被袶裒裨裴裵褊褜襻覑覕覫詊評諀諞諩譜譬评谝谱豼豾貔貧貵賆賠贌贫赔趴跑跘跰踫蹁蹒蹣蹼軯軳軿輣輧輫轡辔辟迫迲逄邳郫郱鄱配酦酺醅醗醥醱釙釽鈚鈹鉕鉟銔銢鋪鋬錃錇錋錍鎃鎜鎞鏷鏺鐅鐠鑝鑻钋钷铍铺锫镤镨閛闏闝闢阫阰陂陠陪陴隦雱霈霶霹靤鞄鞶韸韼頖頗頩顠顰颇频颦飃飄飘馪馷駊駍駓駢騈騗騙騯驃驞骈骗骠骿髈髬髼鬅鬔魄魒魮魾鮃鮍鯆鰟鰾鲆鲏鳑鴄鵧鵬鶣鷿鸊鹏麃麅麭鼙龎龐]',
		\ 'q' : '[七丌且丘丠乔乞乹乾亁亓亝亟亲仇仟仱企伣伹伽佉佢佥佺侨侵俅俏俔俟倛倩倾偂傔傶傾僉僑僛僺儙儝儬全其冾凄凊切刋刞券前剘剠劁劝劬勍勤勧勪勸匤匧区區千卡卭却卷卻卿厒厱厺去取叴吢吣启呇呛呮呿咠唒唘唚唭唴啌啐啓啔啟啨啳喬嗆嗛嗪嗴嘁嘺噐噙器囚囷圈圊圏圱圲圶圻坅坥坵埆埐埢埥埼堑塙塹墄墏墘墙墝墧墻墽壍壳夋夝夡奇奍契奷妻妾姾娶娸婍婘婜媇媊媝嫀嫱嫶嬙嬱孯宆宭寈寑寝寢寴将屈屺岂岍岐岒岓岖岴峑峠峤峭峮崅崎崷嵌嵚嵜嵰嶇嶈嶔嶜巏巧巯巰帢帩帬帺幧庆庈庼廎廑廧弃弮強强彊忂忯忴怯恘恮恰恷悄悏悓悛悫悭悽情惓惬惸愀愆愒愜愨愭慊慤慬慳慶慼慽憇憈憌憔憩懃懄懠戌戕戗戚戧戵扏扦扲抋抢抾拑拤拪拳挈捦捿掅掐掑掔掮揵揿搇搉搝搴搶搼摖摤撁撬撳撽擎擏擒擖攐攑攓攲敧敲敺斉斊斨斪斳旂旗昑晴晵暒暣曲朅朐期朹权杄杞枪柒栔栖桏桤桥桼梂梫棄棈棊棋棤棨棬棲棾椌椠椦楸榩榷榿槍槏槗槧槭樈権樯樵橇橋橩橬檎檠檣檱檶檾櫀櫏櫦櫵權欋欔欠欦欫欹欺欽歉歧歬殎殏殑殸毃毬氍气気氢氣氫氰求汓汔汘汧汽沁沏泅泉泣洤洯洽浀浅浗淁淇淒淭淸淺清渞渠湆湇湫湬湭湶溬溱滊漀漆漒潛潜澿濝濪濳瀙灈灊炁炔炝烇焌焪焭煀煢煪熍熗燆燋燩爠牄牆牵牶牷牽犈犍犞犬犭犮犰猉猐獇玂玌玘玱珡球琦琪琴琷琹琼瑔瑲璂璆璖璚璩瓊瓗甈甠畎畦疧痊瘸瘽癄癯癿皘皳皵盀盚盵睘瞏瞧瞿矜矵砌硂硈硗硘硚硞确碁碃碏碕碛碶確碻磜磧磩磬磲磽礄礐礭祁祇祈祛祺禥禽秋秌秦稽穐穕穷穹窃窍窮竅竆竊竏竒竘竬笉笡笻筁筇筌签箐箝箞箧篋篍篏篟篬簯簱簽籏籖籤籧粁粬粸糗紌紪紶絇絟絿綅綣綥綦綪綮綺緀緧縓縴繈繑繦繰繾纤绮绻缉缱缲缺缼罄罊羌羗羟群羬羻翑翘翹耆耝耹聺肍肣肵肷胊胠胢脐腔膁臍臞臤舼艢艩芁芊芍芑芞芡芩芪芹苘苣茄茕茜茾荃荍荞荠荨莍菃菣菦菬菳萁萋萕萩葋葜葝葥葲葺蒛蒨蓲蔃蔳蔷蕁蕉蕎蕖蕲薔藄藑藒藭藮藽蘄蘒蘠蘧虇虔虬虯蚈蚑蚔蚙蚚蚯蛆蛐蛩蛪蛬蛴蛷蜝蜞蜣蜷蜸蜻蝤蝵蝺螓螧螶螼蟗蟝蟿蠄蠐蠤蠷蠸蠼衐衢衾袪袷裘裙裠褀褄褰襁襅覃親覰覷覻觑觓觠觩訄訅訖詓詘詮誚誛誳請諐諬謒謙謦譙譴讫诎诠诮请谦谯谴谸豈賕赇起赹赾趄趋趍趞趣趥趨趫趬跂跄跒跧跫跷踍踡踥踦蹊蹌蹡蹺躈躣躯軀軝軡軥軽輇輕輤轻辁迁迄迉逎逑逡遒遣遷邔邛邱郪郬郻鄡鄥鄿酋酠醔醛釚釥釮釺釻鈆鈐鈙鈫鉗鉛銎銓銭銶鋟錆錡錢鍥鍫鍬鎆鎗鏘鏚鏲鏹鐈鐉鐑鐰鑋鑺钎钤钦钱钳铅铨锓锖锜锲锵锹镪閴闃闋闎闕闙阒阕阙阡阹陗陭雀雂霋靑青靘靬靲鞒鞘鞦鞧鞩鞽韆韏韒頃頄頎頝顅顉顦顴顷颀颧駆駈駩駸騎騏騚騝騡騫騹驅驱骎骐骑骞骹髂髚髜髷鬈鬐鬜鬝鬿魌魼鮂鮼鯄鯕鯖鯜鯱鰁鰌鰍鰬鰭鰸鰽鱋鲭鲯鳅鳈鳍鳹鴝鵆鵭鵮鵲鵸鶀鶈鶌鶖鸜鸲鹊鹐鹙麇麒麡麮麯麴麹黔黚黢黥鼁鼩鼽齊齐齤齲龋龝龟蘒]',
		\ 'r' : '[乤乫乬乭乮乳乶乺乼乽人亻仁仍仞仭任侞偄偌傇傛儒儴入冄冉冗刃刄勷厹叒叡呥喏嗕嘫嚅嚷囸坈堧壌壖壡壤壬如妊姌姙娆婼媃媆媣媶媷嫆嬈嬫嬬孺宂宍容屻峵嵘嵤嵶嶸嶿帤弱忈忍忎惹懹戎扔扖扰挐挘挼捼揉搈搑撋擩擾攘日曘曧朊朲杁杒枘染柔栄栠栣桇桡桵梕楉楺榕榮榵槦橈橍橤橪毧氄汝汭洳润渃渘渪溶溽潤濡瀜瀼热烿焫然煣熔熱燃爃爇爙牣狨獽珃瑈瑌瑞瑢瓀瓇瓤甤睿碝礝礽祍禳禸秂秹稔穁穃穣穰筎箬篛粈糅紉紝絍絨緌緛縙縟繎繞繠纫纴绒绕缛羢耎肉肕肗肜肰脜腍腝腬膶艝艿芢芮芿苒若茙茸茹荏荛荣荵葇葚蒘蒻蓉蓐蕊蕋蕘蕠蕤薷蘂蘃蘘虄蚋蚦蚺蜹蝚蝡蝾融螎蠑蠕衵衻衽袇袡袵袽褣褥襓襦訒認譲譳讓认让讱蹂躟躮軔軟軵輭輮轫软辱辸遶邚鄀鄏醹釰釼鈓鈤銋銣銳鋭鍒鎔鑓铷锐镕閏閠闰阮陾隢靭靱鞣韌韖韧顬颥飪餁饒饪饶馹駥騥驲髥髯鬤魜鰇鰙鰯鱬鴑鴽鵀鶔鶸]',
		\ 's' : '[丄三上世丗丝丧乄乘书乨乷乺亊事亖亗什仕仨伞伤伸伺似佀佘佦使侁侍価侸侺俕俗俟俬倏倐倠倯倽偗偲傁傃傓傘傞傱傷傻僐僧僳僿儍儩儵兕兘兟兽冞冟凁凇凘删刪刷刹剡剩剰剼劭势勝勢勺匙匴十卅升卋单卛卲厁厍厑厕厙厦厮厶叁参双収叔受叜叟史叶司吮呏呞呩呻咝咰哂哨哸唆唜唢唦售唰唼商啑啥啬善喢喪嗄嗇嗉嗍嗓嗖嗜嗣嗦嗩嗮嗽嗾嘇嘘嘥嘶噎噝噬噻囌四圣圸垧垨埘埣埽堔塐塑塒塞塽塾墅墒墠墡墭士壭声壽夀夊夙失奢奭妁妽始姍姒姗姝姺姼娀娋娑娠娰婌婶媤嫂嫊嬕嬗嬘嬸孀孇孙孠孫孰守宋实実审室宩宿寔實審寺寿射尌少尗尙尚尸尿屍屎属屬山屾岁峕峙峷崧崼嵊嵗嵩嵵嵷巳市帅师帥帨師帹幓庶庺庻廀廈廋廝弎式弑弒弞弰弽彡徥忕忪怂思怷恀恃恕恖恦悚惢愢愫愬愯愼慅慎慑慡慫慯慴憟憴憽懎懾戍戺所扄扇手扌扟扨扫抒折拭拴拾挱挲挻捎捒捜损捨掃授掓掞掸掺掻揌揓揲損搎搔搜搠搡搧摂摄摅摉摋摍摔摗摵撒撕擅擌擞擻攄攝收敒散数數敾斘斯施旓旕旞时旹昇昚是昰時晌晒晟晠晱暏暑暛曋曑曙曬書曻朔朮术杀杉杓束杫杸松枀枡枢枩枱枾柖柗柛柵柶柹柿栅栍树栓栜栻桑桒桫桬梀梢梥梩梭梳森棯椫椮椹楒楤楯榊榝榡榫榯榹榺槂槊槡槮樉樎樕樞樧樹樿橓橚橳橾檆檖檧檨櫒櫢櫯欆欇欶歃歙歚歮歰歲歳死殅殇殊殐殖殤殳殺毢毵毶毸毹毺毿氉氏氠水氵氺汕汜汤沈沙沭泀泗泝泤泩泷洍洒洓洠洬浉浽涁涉涑涗涘涚涩涭涮涻淑淞深渉渋渑渖渗渻湜湤湦湿溑溞溡溮溯溲溸溹溼滖滠滲滳漡漱漺潄潚潠潥潲潵潸潻澀澁澌澍澘澨澻濇濉濍濏濕濖瀃瀋瀒瀡瀭灀灄灑灗炶炻烁烒烧焂焺焼煔煞煫煶煽熌熟熣熵燊燍燒燥燧爍爽牭牲犙狌狦狩狮狲狻猀猞猻獀獅獡獣獸率玊玿珄珅珊珟琐琑琞琡瑟瑡瑣璅璛璱璲璹瓍甚生甡甥甦甧甩申畬畭畲疎疏疝痁痠痧痩瘆瘙瘦瘮瘶瘷癙盛省眂眎眒眘眚眡眭睃睄睒睗睟睡睢瞍瞚瞤瞫瞬矂矟矢矤矧石砂砕砷硕硰硹碎碩碿磃磉磰礵示礻社祀祏祘神祟祱祳禅禓禗禠禩禪禭私秫秲稅稍税稣穂穌穑穗穟穡穯穼窣竍竔竖竢竦竪笇笋笘笙笥笶筍筛筭筮筲箑算箰箷箾篩簁簌簑簓簔簛簨簭簺籂籔籡籭籶籸粆粛粟粹糁糂糝糣糤糬糹紓紗素索紳紹絁絉絲綀綏綤綬緔緦縄縇縔縤縮縿繀繅繉繐繕繖繩繬繸繺纟纱纾绅绍绥绱绳绶缌缩缫缮罙罧署罳羧羴翜翣耍耛耜耸聖聲聳肂肃肅肆肾胂胜脎脠脤脽腎腧腨腮膄膆膳膸膻臊舌舍舎舐舒舓舜舢艄艏艘艭色芍芕芟苆苏苕苫苼荗荪荼荽荾莎莏莘莤莦莳菘菽萐萨萷葚葠葹蒁蒅蒐蒒蒔蒜蒴蓀蓃蓍蓑蓡蔌蔎蔏蔘蔬蔱蕂蕣蕬蕯蕱蕵蕼薓薞薥薩薮薯藗藪藷蘇蘓蘰虄虒虪虱虵虽蚀蛇蛥蛳蛸蜀蜃蜄蜤蜶蝕蝨螄螋螦螪螫蟀蟖蟮蟴蟺蠂蠴術衫衰袑裋裑裞裟裳褨褬褷襂襚襡襩襫襷襹視覗覢覾视觞觢觫觴訕訟訠設訯訴訷試詩詵誓誜誦說説誰誶諗諟諡謆謖謚謪譅識譝譢譱讅讪讼设识诉试诗诜说诵谁谂谇谉谡谥豎豕貄貰貹賒賖賞賥賸賽贍贖贘贳赊赎赏赛赡赦赸趖趚跚跾踈蹜躠身躮躻軕軗軾輋輎輸轖轼输辻述送适逝速逤遀遂遈遡適遬遾邃邖邥邵邿鄃鄋鄯酥酸酾醙釃釈释釋釤釲釶鈒鈰鈶鈻鉂鉃鉇鉎鉐鉥鉮鉰鉽銏銫銯銴鋉鋖鋠鋿錰鍟鍦鍶鎍鎖鎙鎟鎨鎩鎪鎹鎻鏁鏉鏒鏛鏣鏯鏼鏾鐁鐆鐡鐥鐩鑜鑠钐钑铄铈铩铯锁锶锼閂閃閐閪閯閷闩闪阇阩陎陕陝陞陹隋随隡隧隨隼雖雙雭霎霔霜靸鞖鞘鞝韘韢韶順頌頣顋顙顺颂颡颯颸颼颾飋飒飔飕食飠飤飧飱飼飾餗餙餝餸餿饊饍饣饰饲馊馓首馺駛駟駪駷騇騒騦騪騷騸騻驌驦驶驷骕骚骟骦髄髓髞髾髿鬆鬊鬖鬙鬺魦魫鮖鮛鮹鮻鯂鯅鯊鯋鯐鯓鯳鯴鯵鰓鰘鰠鰣鰤鰺鱐鱓鱔鱛鱢鱪鱰鲥鲨鲹鲺鳃鳋鳝鳲鳾鵢鵥鵨鵿鶍鶐鶳鶽鷞鷥鷫鸘鸤鸶鹔鹴麝黍鼠鼪鼫鼭鼶﨎﨡]',
		\ 't' : '[乇亠亭他仛仝伖佃体佗佟佻侂侗侤侹侻俀俶倎倓倘倜偍偒停偷偸傏傝傥僋僓僣僮儓儯儻兎兔兲冭凃凸剃剔剸劏勭匋厅厗厛叨台叹同吐吞听呑呔呫咃咜咷哃唋唐唺唾啑啕啴啺啼嗁嗒嗔嗵嗿嘆嘡嘽噋嚃嚏嚔嚺团団囤図囼图圕圖圗團土圡圢坉坍坛坣坦坨坮垌埮堂堍堗堶塌塔塗塘塡填墖墥墰墵壇壜天太夲夳头套她妥妵娗娧婒婖婷婾媞媮嫍嫷嬥嬯孡它宊宨尵屇屉屜屠屯岧岮岹峂峒峝峹崉崹嵉嵞嶀嶞帑帖幍幐庁庝庣庩庭庹廜廰廳廷弚弢弹彖彤彵徒徲忐忑忒忝忲忳态怗怢怹恌恫恬恸悇悌悐悿惔惕惖惝惿慆態慝慟慱憅憛憳憻戃戻托扡扨投抟抬拓拕拖挑挞挩挮挺捅捈捝捸掏探掦推掭提揥揬搨搪搯搷摊摥摶撻擡擹擿攤敨斢旫旲旽昙晀晍晪暺暾曇曈曭替朓朜朣朰杔条柁柝桃桐桯桶梃梌條梯梼棠椭楕楟楿榃榙榳榶榻槄槖槫樋樘樤橐橔橖橝橢橦橽檀檯檲歎歒殄殢毤毯毻毾氃氽汀汏汑汢汤汰汱沓沰沱沺泰洟洮浵涂涋涏涒涕涛涶涾淌淘淟添渟渧湉湍湠湥湪湯溌溏溙溚溻滔滕滩漙漛漟漯漽潬潭潳潼澹澾濌濤灘炭炱炲炵烃烔烫烴烶焘焞煓煺煻熥燂燑燙燤燵爣牠特犝狏狧狪猯獞獭獺珽琠瑅瑫瑭瑱瑹璮璳瓋甛甜田町甼畋畑畠畽疃疼痋痌痑痛痜痰痶瘏瘫癱眮眺睓睼瞳矘砣砤砼碢碮碳碵磄磌祂祒祧祹禟禢禵禿秃秱稊稌穜穨突窕窱窴童笤笹筒筡筩筳箈箨篖篿籉籊籐籘籜粏粜粡糃糖糛糰糶紏紽絛絧絩統綂綈綎綯緂緹縚縢縧统绦绨绹缇罀罈罎罤羰耓耥聎聑聤聴聼聽肽胋胎脁脡脦脫脱腆腯腾腿膅膛膧膯臀臋臺舑舔舕舚舦艇芀芚苔苕茼荑荼莌莛莵菟菭菼菾萄萔萙萚萜葖葶蒤蓎蓚蓨蓪蓷蕛薙薚薹藤藫藬蘀蘈蘣蘰虅蚒蛈蛌蛻蜓蜕蜩蜪蝏蝪螗螣螳蟘衕袉袒袥裪裼褅褆褖褟褪襨襷覃覜覥觍討託詑詜詷誂誊誔誻談諪謄謕謟譚譠譶讨讬说调谈谭豘豚貒貚貪貼賟贪贴赨赯趒趟趧趯趿跅跆跎跳跿踏踢踼蹄蹆蹋蹏蹚蹪蹹躢躰躺躻躾軆軘轁迌迢迯退逃透途逖通逷遆遝遢邆邒邰郯鄌酞酟酡酮酴醄醈醍醓醣醰釷鈦鈯鉄鉈鉖鉭鉵銅銕銻鋀鋌鋚鋱鋵鋾錔錟錪鍎鍗鍮鎕鎥鎲鏄鏜鐋鐡鐵钂钍钛钽钿铁铊铜铤铴铽锑锬镋镗閮闐闒闛闥闼阗阘阤陀陁陶隚隤霆霕霯靔靝鞀鞉鞓鞗鞜鞱鞳鞺韜韬頭頲頹頺頽顃題颋颓题颱飥飩飸飻餂餇餮餹饀饄饕饦饨馟馱馲駄駘駝駞駣駦駼駾騊騠騨騰驒驖驝驣驮驼骀骰骵骽體髫髰鬀鬄魄魋魠魨鮀鮐鮙鮦鮲鮵鮷鯈鯳鯷鰖鰧鰨鰰鰷鱩鲀鲐鲖鲦鳀鳎鴕鴫鵇鵌鵎鵚鵜鵵鶎鶗鶙鶟鶶鷆鷈鷉鷋鷏鷒鷤鷵鷻鸵鹈黇黈黗鼉鼍鼗鼞鼟鼧鼮鼵齠龆]',
		\ 'w' : '[万丸为乌乛五亡亹亾仴仵仼伆伍伟伪位佤侮俉倇倭倵偉偎偓偽僞儛儰兀免兦刎刓剜剭务劸務勜勿午卍卐卧卫危卼厃厼叞吳吴吻吾呅呉呜呡味咓咼哇唍唔唩唯啎問啘喂喎喔喡喴嗗嗚嗡嗢囗囲围圍圩圬坞埦塆塕塢塭墛墲壝壪外奣奦妄妏妧妩委威娃娒娓娪娬娲婉婐婑婠婺媁媉媙媦媧嫵完宛寤寪尉尢尣尩尪尫尾屋屲屼岉岏峗峞峿崣崴嵍嵔嵡嵨嵬嶉嶶巍巫帏帵帷幃幄庑廆廡弙弯彎彣彺往徃徍徫微忘忢忤忨怃恶悞悟悮惋惘惟愄愇慰憮懀戊我扤抆抏挖挝挽捂捖捤捥捰捾揋握揻揾搲搵摀撱攚攨敄文斖斡於无旺旿昷晚晤晥晩晼暀暐暡望朢未朰杇杌杤枂枉桅桽梚梧梶棢椀椲椳楃楲楾榅榲橆欈歍武歪殟毋汍汙汚污汪汶沃沩洈洖洧洼洿浘浯涠涡涴涹渂渥渦渨温渭湋湾溈溛溦溩溫滃漥潍潕潙潫潿澫濣濰濻瀇瀢灣炆炜為烏烓烷焐無焥煒煟煨熃熓熭燰爲物牾犚犩猥猧猬王玝玩玮珳珷珸琓琟琬瑋瑥瑦璑璺瓁瓦瓮瓸瓾甅甒甕畏畖畹痏痦痿瘒瘟癓皖盌睕瞃瞈瞣瞴矀矹砙硊硙硪碔碗碨磑祦稳穏穩穵窊窏窐窝窩窪窹竵笂箼粅紈紊紋絻綩維綰網緭緯緼繧纨纬纹维绾罋网罒罓罔罻翁翫聉聞聬肟肳胃脕脗脘腕腛腲腽膃臒臥舞艉芄芛芜芠芴苇苿茣荱莁莞莣莬莴菀菋菵萎萖萬萵葦葨葳蒍蓊蓶蔓蔚蔿蕪蕰蕹薇薍薳藯蘁蘶蚉蚊蚟蛙蛧蜈蜗蜲蜼蜿蝄蝛蝟蝸螉螐螡螱蟁蟃蟱衛袜褽襪覣覹詴誈誣誤誷諉謂譕讆讏诬误诿谓豌豱貦贃贎踒踓踠躌躗躛躵躻軎輐輓輞輼轀轊辋辒迋迕违逜逶違遗遤邬邷郚鄔鄬醀鋄鋈鋔鋙錽鍏鍡鎓鎢鎫鎾鏏钨铻閺閿闅闈闦问闱闻阌阢陚隇隈隖隗雯雺雾霚霧霨霺靰鞰韈韋韑韙韡韤韦韪頑頠顐顡顽颹餧餵饂饖馼駇騖骛骩骪骫魍魏魰鮇鮠鮪鯃鯲鰃鰄鰛鰞鰮鲔鳁鳂鳚鳼鴍鴮鵐鵡鶩鶲鷡鹀鹉鹜鹟鼃鼤鼯鼿齀齆齷龌兀]',
		\ 'x' : '[丅下习乡乴些享亯亵仙仚伈休伨伩伭伳伵佡佭侀侐侚侠侾係俆俙俠信俢修俲俽倖假偕偞偦偰偱傄傒傚僁僊像僖僩僲僴儇兄兇先兮兴冔写冩冼凞凩凶刑券削劦効勋勖勗勛勨勰勲勳匂匈匣匸卂卌协協卥卨卸卹厀厢厦县叙叶吁吅向吓吷吸呬呴呷呺咁咞咥咲咸咺咻哅响哓哘哮哯唏唟唬唽啣啸喜喣喧喸喺嗅嗋嗛嘋嘐嘕嘘嘨嘯嘵嘻噀噏噓噚噧噱噷噺嚊嚑嚡嚣嚮嚱嚻囂囍囟圩圷坃坹型垥垶垷垿埉埙埳塇塈塤塪塮墍墟壆壎壏壐壦壻夏夐夑夓夕夞奊契奚奞奾妡妶姁姓姠姭娊娎娙娭娴娹婋婞婱婿媗媟媭媳嫌嫙嫺嫻嬃嬆嬉嬐嬜嬹孅孈孝孞学學宣宪宯宵宿寫寻尋小尟尠屃屑屓屖屟屣屧屭屳岘岤岫峀峃峋峡峫峴峽崄崤嵠嶍嶑嶨嶮嶰巂巇巡巪巷巺巼巽希席幰幸序庠庥庨廂廞廨廯廵弦弲彇彐形徆徇徐徙徢循徯忀心忄忚忥忷忺忻性怬怰怴怸恂恄恊恓恔恟恤息悉悕悬悻惁惜惞想惺愃愋愶愻慀慉憘憙憢憪憲憸懁懈懗懸戌戏戯戱戲扸拹挟挦挾掀揎揗揟揱揳搟携撊撏撨撷擕擤擷攇攕攜攳效敍敘敩敮敻斅斆斈斜新旋旪旬旭旴昍昔昕星昡昫显晅晇晑晓晛晞晰晳暁暄暇暊暬暶暹暿曉曏曐曛曦朂朽杊杏杴杺析枔枭枮枲枵柙栒栖栙校栩桖桪桸梋梟械梺梻椞椺楈楔楥楦榍榭榽槒槢樇樨樰樳橀橌橡橲橺檄檈櫶櫹欀欣欨欯欰欷欻歆歇歊歔歖歗歘歙殈殉殽殾毊毥毨氙氥汐汛汹汿沀泄泫泶泻洐洗洨洩洫洵洶浒浔浚浠涀消涍涎涬淅淆渓渫渲湑湘湺溆溪溴滀滎滫漇漝漩漵潃潇潊潝潟潭潯澖澙澥澩瀉瀗瀟瀣瀥灥灦灱灲灺炘炠炧炨炫烅烋烌烍烚烜烯烲烼焁焄焇焈焎焟焬焮焸焽煆煊煋煕煖煦熁熂熄熈熊熋熏熙熹熺熻熽燅燖燢燨燮燲燸燹燻爋爔爕牺犀犔犠犧狌狎狘狝狥狭狶狹猃猇猩献猲獝獢獫獬獮獯獻玁玄现玹玺珗珛珝珣珦珨珬現琁琄琇琋瑄瑆瑎瑕璇璓璕璽璿瓖瓨甉畃畜疜疞疶痃痚痟痫瘜癇癎癣癬皙皛皢皨盢盨盱盷相盺盻省県眩眴睍睎睱睲睻瞁瞎瞦瞯瞲矄矎矖矽砉硎硒硖硝硣硤硳碬碹磍磎磶礂礥祄祆祥祫禊禑禒禤禧禼秀秈稀稄稧稰稴稸穘穴穸窙窨窸笑筅筪筱筿箫箮箱箲箵篂篠簘簫籼粞粯糈糏糔糦糮系紃細紲絃絏絜絢絤絬絮絴綃綇綉綊綌続綫緆緈緒緖緗線緤緰緳縀縃縅縖縘縣縰縼繊繍繏繡繥繫繲繻纁纈續纎纕纖纤线绁细绚绡绣绤绪续缃缐缬缷缿罅羞羡羨羬羲翈習翓翔翕翖翛翧翾聓聟聢肖肸肹胁胘胥胷胸脅脇脋脙脩脪腊腥腺膎膝膤膮膷臐臔臖臭臹臽舃舄興舋舝舷舺舾芎芗芧芯苋苬苮茓茜荀荇荤荥荨莃莕莘莧莶莻菥萧萫萱萲葈葕葙葭葸蒆蒠蒣蒵蓄蓆蓒蓰蓿蔙蕈蕦蕭蕮蕸蕿薂薌薛薟薢薤薪薫薰藃藇藓藖藚藛藼蘍蘐蘚虈虓虗虚虛虩虾蚃蚬蚿蛝蛵蛸蜁蜆蜥蝎蝑蝖蝢蝦螅螇螑蟂蟋蟏蟓蟢蟰蟳蟹蠁蠉蠍蠏蠨蠵血衅衋行衒衔衘衺袕袖袨袭裃裇裼褉褎褏褶褻褼襄襐襑襭襲襳西覡覤见觋解觪觲觷觹觽觿訊訏訓訙訢訤訩訫許訹詗詡詢詨詳詾誟誢誵誸諕諝諠諧諰諴諼諿謃謏謑謔謝謵譃譆譞譣讗训讯许讻诇询详诩谐谑谖谞谢谺谿豀豏象豨豯貅貕賉賢賯贒贙贤赥赩赮赻趇趐趘跣跭跹踃踅蹊蹝蹮躚躞躧躾軐軒輱轄轌轩辖辛辥辪迅迿选逊逍遐遜選邂邜邢邤邪郄郇郉郋郗郤郩郷鄉鄊鄎鄕鄦鄩酅酗酰醎醑醒醯醺釁釳釸鈃鈊鈢鉉鉨鉩鉶銄銊銑銒銛銜銝銷銹銽鋅鋗鋞鋧錎錫鍁鍌鍜鍹鎀鎋鎴鎼鏅鏇鏥鏬鏭鏽鐊鐌鐔鑂鑐鑦鑫鑲鑴钘铉铏铣铦销锈锌锡锨镟镡镶閑閒閕閜闟闲阋阠陉降限陘陜陥险陷険陿隙隟險隰隵雄雪需霄霞霫霰霼靴靾鞋鞙鞢鞵鞾韅韯韰韱響項須頊顕顖顨顯项须顼颬颴颵飁飍飨餉餏餡餳餼饈饎饗饟饧饩饷饻馅馐香馦馨馫馴馸駨駽騂騢騱騽驉驍驤驨驯骁骍骧髇髐髤髹鬚鬩魆魈魖魣魻鮏鮝鮮鮴鯐鯗鯱鯹鰕鰼鱃鱈鱌鱏鱘鱚鱮鱶鱻鲑鲜鲞鲟鳕鳛鴞鴵鵂鵗鶱鶷鷍鷳鷴鷼鷽鸂鸮鸴鸺鹇鹹麘麙麲黖黠鼷鼸齂齅齘齛齥龤﨏﨧]',
		\ 'y' : '[ㄝ一丆与业丣严丫乁乂义乐乑乙也乵亄予于亐云亚亜亞亦亪亱亴亿仡以仪仰仸伃伇伊优伛伝伢佁佑佒余佚佣佯佾侇侌侑依侥俁俋俑俞俣俨俹俼倄倚倻偀偃偊偐偠偤偯傆傊傜傟傭傴傿僌僪僷儀億儥優儼允元兖兗兪养兿円冘冝冤冴冶凐凧刈刖剈剡剦劓劜劮劷勇勈勚勩勻匀匇匜匬医匽卣卬印厊压厌厓原厡厣厭厳厴厵又友右叶吁吆吔吖吚吟吲呀呓员呦呭呹咉咏咦咬咽咿哊哑哕哟員唀唁唈唖唷唹啞啱喁喅喑喓喗喦喩喭喲営喻嗂嗈嗌嘢嘤噎噖噞噟噦噫噮噰噳噾嚈嚘嚚嚥嚴嚶囈囐囙因囦囩园囿圁圄圆圉圎園圓圔圛圜圠圧圫圯圻坄坱垔垚垟垠垣垭垸垼垽埇埏埜域埡埶埸堉堐堙堣堬堯堰堷塋塎塩塬墉墕墷墿壄壅壓壛壧壱壹夁夗夜夞夤夭央夵夷夽奄奕奫妍妖妘妜妟妤妪妴姎姚姨姲姷姸姻娅娛娫娮娯娱婣婬婭婴婹媀媐媖媛媱媴媵嫄嫈嫕嫗嫛嫞嫣嬄嬊嬑嬟嬩嬮嬰嬳嬴嬽嬿孆孍孕孧孲孾宇宎宐宜宥宧宴寃寅寓寙寱寲尉尢尤尧尭尹尾屹屿岃岄岆岈岟岩岳峄峓峟峣峪峳峾崕崖崟崦崯崳崵崸崺崾嵃嵎嵒嵓嵛嵱嵼嶎嶖嶢嶤嶧嶪嶫嶬嶷嶼嶽嶾巆巊巌巖巗巘巚已巸帟帠幆幺幼幽庌应庘庡庮庸庽庾廕廙廮廱廴延异弇弈弋弌引弬彛彜彝彞彥彦彧彮影役徉御徭徼忆忔応忧忬怈怏怞怡怣怨怮怺怿恙恞恱恹恽恿悀悅悆悒悘悠悥悦惌惐惥惲愈愉意愑愔愚愝愠愥愪愮愹愿慂慃慇慍慭慵慾憂憖憗憶應懌懕懙懚懨懩懮懿戉戫戭扅扆扊扜扝扬扵抁抈抎抑抣抭抰抴押拥拸拽挜挧挹捓捙捳掖掗掩掾揄揅揖揚揜揠援揶揺搖摇摬摿撄撎擁擛擨擪擫攁攍攖攸攺敔敡敥敭敼斁斔斞斦於旑旖旟旸昀易昖昜映昱昳晏晔晕晹晻暆暈暍暎暘暚暥曀曄曅曎曕曗曜曣曮曰曱曳曵朄月有朠杅杙杝杨杬杳枍枒枖枟枻枼枽柍柚柡柼栍栎栐栘栧栯栶样桋桙桜桠梄梬棛棜棩棪棫棭椅椏椬椰椸椻椼楀楆楊楌楡楢楧業楰楹榆榏榚榞榣榬様槱槸樣樮樱樾橒橼檃檍檐檥檭檹檼檿櫌櫞櫩櫲櫻櫽櫾櫿欎欝欤欥欭欲歅歈歋歝歟歶殀殃殒殔殗殞殥殪殷殹毅毉毓氜氤氧氩氬氱氲氳永汩沂沄沅沇沋沶油沿泆泑泧泱泳泿洇洋洕洢浂浟浥浧浳浴涌涢涯液涴淊淢淤淫淯淵淹淾渁渆渊渏渔渕渝渰渶渷游湙湚湡湧湮湲湵溁溋溎源溒溔溢溳溵滛滟滢滧滪滺滽漁漄演漜漪漹漾潁潆潏潩潱澐澞澦澭澲澺濙濚濥濦濴瀀瀁瀅瀛瀠瀯瀴瀷瀹灁灉灎灐灔灜灧灩灪炀炈炎炏炴烊烎烑烟烨烻焉焔焰焱焲焴煐煙煜煠煬煴熅熉熎熒熖熠熤熨熪熼燁燄燏燕燚營燠燡燱燿爓爗爚爩爰爷爺爻牅牏牖牗牙牪牰犹犽犾狁狋狕狖狱狳狺狿猌猒猗猚猨猰猶猷猺猿獄獈獟玉玗玙玡玥玴珆珚珜珢珧珱琂琊琙琰瑀瑒瑗瑘瑛瑜瑤瑩瑶瑿璌璍璎璵瓔瓵甇甖甗用甬由甴畇畩畬異疋疑疟疡疣疨疫痈痍痒痖痬瘀瘂瘉瘍瘐瘖瘗瘞瘱瘾瘿癊癒癔癕癢癭癮癰皣盁盂盈益盐盓盶眃眏眑眙眢眻眼睚睪睮瞖瞱瞸矅矞矣矨矱砑研砚砡砽硏硢硧硬硯硲硽碒碞碤磒磘磤礇礏礒礖礜礢礯礹礿祅祎祐祤禉禋禐禕禜禦禴禹禺秇秐秗秞秧秵移稏稢稦稶穎穓穥穻穾窅窈窑窔窨窫窬窯窰窳竩竽笌笎笖筃筄筠筵筼箊箢箹篒篔篗篶篽簃簷籅籆籎籝籞籥籯籰籲粌粖粤粥粵約紆紜紻絪綖緎緓緣緸縁縈縊縕縜縯繄繇繶繹纅纋纓纡约纭绎绬缊缘缢缨罀罂罃罌罨罭羊羏羑羕羠義羱羽羿翊翌翳翼耀耘耰耴耶耺聈聐聿肀肄肊肙肬育肴胤胦胭胰腋腌腪腰腴膉膡膺臃臆臙臾舀舁舆與舣艅艗艞艤艳艶艷艺艾芅芋芌芫芸芽苃苅苑苚苡苢苭英茒茔茚茟茰茵荑荛荥荧荫药荶荺莚莜莠莸莹莺菀菸萒萓萟萤营萦萭萮萸萾葉葯葽葾蒀蒏蒑蒕蒝蒬蒮蒷蓔蓣蓥蓹蓺蔅蔚蔩蔭蕍蕓蕕蕥蕴蕷薀薁薏薗薬藀藙藝藥藴蘊蘌蘙蘛蘟蘡蘥蘨虉虞虤虶蚁蚎蚏蚓蚖蚜蚰蚴蛇蛍蛘蛜蛡蛦蛹蛾蜎蜏蜒蜟蜮蜴蜵蝆蝇蝓蝘蝝蝣蝤蝧蝯蝹蝿螈螔螘螠螢螸螾蟫蟻蠅蠮蠳衍衏衙衣衤衧衪袁袎袘袣袬裀裔裕裛裫裷裺裿褎褑褕褗褞褤褮褹襅襼襾覀要覎覞覦覮觃觎觺觾言訁訑訔訚訝訞訡訧訮訲訳詇詍詏詒詠詣詽誃誉誘語誼誾諛諭諲諹諺謁謍謜謠謡謣謻譍譩譯議譻譽讉讌讑讔讛讞讠议讶译诒诣语诱说谀谊谒谕谚谣谳谷豓豔豙豛豫豷貁貐貖貟貤貽賏賱賹贀贇贋贏贗贠贻赝赟赢赺越趛跀跃跇跠踊踦踰踴躍躽軅軈軉軋軏軮軺軼輍輏輑輢輰輶輿轅轙轝轧轶轺辕辷込迂迃迆迎运迓远迤迱迶迻逌逘逰逳逸逺逾遃遇遊運遗遙遠遥遹遺邀邍邎邑邕邘邧邪邮邺郁郓郔郢郧郵郺郼郾鄅鄆鄓鄖鄘鄞鄢鄴鄾酀酉酏酑酓酝酭酳酽醃醖醞醟醧醫醳醶醷醼釅釉野釔釴釾鈅鈏鈗鈘鈝鈠鈺鈾鉞鉠鉯銀銉銥銦銪銯鋆鋊鋣鋺錏錥鍈鍚鍝鍱鎁鎐鎑鎣鎰鎱鏔鏞鐚鐛鐭鐷鐿鑍鑓鑰钇钖钥钰钺铀铅铔铕铘铟铫铱银铻锳镒镛镱閆閱閲閹閻閾闄闉闏闫阅阈阉阎阏阣阥阦阭阳阴阽陓院陨陰陶陻陽隁隂隃隅隐隒隕隠隩隱隿雁雅雍雓雝雤雨雩雲雵霒霙霠霣霪霬霱霷靥靨靷靿鞅鞇韗韞韫音韵韺韻韾頁頉預頤頥頨頴顊顏顒顔顗願顤顩页预颍颐颕颖颙颜颺颻飏飖食飫飬飮飲飴餆養餍餘餚餣餫饁饇饐饔饜饫饮饴馀馌馧馭馻駀駅駌駚駰騐験騕騟騴騵驈驗驛驜驠驭驿骃验骬骮髃鬰鬱鬳鬻魇魊魘魚魭魷鮋鮣鮧鮨鮽鯒鯣鯲鰅鰋鰑鰩鰫鱅鱊鱙鱦鱼鱿鲉鲬鳐鳙鳦鳫鳶鳿鴁鴈鴉鴛鴢鴥鴦鴧鴨鴪鴬鴳鴹鴺鵒鵶鵷鵺鶂鶃鶍鶎鶑鶠鶢鶧鶯鶰鷁鷂鷃鷊鷕鷖鷛鷠鷣鷧鷪鷰鷸鷹鷾鸃鸆鸈鸉鸎鸑鸒鸙鸚鸢鸦鸭鸯鸳鹆鹓鹝鹞鹢鹥鹦鹬鹰鹽麀麌麣黓黝黟黡黤黦黫黬黭黳黶黿鼋鼘鼝鼬鼴鼹鼼齖齗齞齦齩齫齬齮齳齴齵齸齾龂龈龉龑龠龥]',
		\ 'z' : '[丁丈专中丵丶主之乍乼乽乿争仄仉仔仗仲伀众传伫伷伿佂佇佋住佐佔作侄侏侜侦侧侲侳俎俧倁倊値倧倬倳债值偅做偡偧偫偬偵偺傂傤傮傯債傽僎僔僮僽儎儧儨儹兂兆兹再冑冢冣准凖凿则刣制則剚剬劄劅劕劗劚劧助劯匝匨卆卒卓占卮厇厏厔厜叀叕只召吇吒吱周呪呰咀咂咋咒咗咤咨咫咮咱哉哫哲哳唑唕唣唨啁啄啅啍啙啠啧啫啭喆喋喌喒喠喳喿嗞嗭嗺嗻嘖嘬嘱嘲嘴噂噆噡噣噪噿嚋嚞囀囃囋囎囑在圳圴址坁坐坠坧坾垁垗埑埩埴執埻堟堫堹塚塟塣塦塼墆墇墌増墜增墸壮壯壴壵夂夈奏奓奘妆妐妕妝妯妰妱妷姃姉姊姕姪姫姿娡娤娷娺婤媑媜嫃嫜嫥嫧嫬嫸嬂孎子孖字孜孨孳孶宁宅宒宔宗宙宰宱寁寊寘寨専專尊尰屒展属屯岝岞岾峙峥崒崝崢崪崭崰崱崻崽嵀嵏嵕嵫嵸嶂嶃嶄嶊嶘嶟嶦嶵州左巵巶帀帋帐帙帚帜帧帪帳帻帾幀幁幒幘幛幟幢幥庂庄庒庢庤座庶廌弉张弫張彘彰彴彸征徏徝徟徰徴徵徸志忠忪忮怍怎怔总恉恣悊惉惣惴惾愸慞慥慹憄憎懥懫戆战戝戠戦戰扎扗扙执扺扻找抍抓折択抧抮抯拀拃拄拙招择拯拶拽挃指挋挓挚挝挣振捉捑捘捚捴捽掌掙掟掫掷揁揍揔揕揝揸搃搌搘搱搸搾摘摠摣摨摭摯摺撍撙撜撞撮撯撰撾擆擇擢擲擳擿攅攒攢攥支政整斀斋斎斟斩斫斬斮斱斲斵斸旃族旐旘旜旨早昃昗昝昣昨昭昮昼晊晝晢晣晫晬晭晸智暂暫暲曌曯曽曾最朕朝朡札术朱杂杍杖杼枕枛枝枞枣枬枳柊柘柚柞柣柤查柱柴柷栀栅栆栈栉栚栥株栬栴栺栽桌桎桚桟桢桩梉梍梓梔梲梽棁棕棗棧棳棷棸棹椊植椎椓椔椥椶椹楂楨楾榐榛榟榨榰榸槎槕槜槠樁樍樜樝樟樦樴樶樼樽橏橥橧橴橵檇檌檛檡櫂櫍櫛櫡櫧櫫欌欘止正歭歱歵歽殖殝殶毡氈氊氏氶汁汄汋汥汦汷沌沚沝沞沢沯治沼沾泈泎泜注泽洅洔洙洲洷浈浊浙浞涨涱涿淄淍淔淛淽渍渚渣渽湛湞湷湽準溠溨溭溱滋滍滓滜滞滯漐漬漲漳潈潌潧潪潴澡澬澵濁濐濯濽瀄瀦灂灒灟灶灷灹灼災灾炂炙炡炢炤炪炷炸炿烐烖烛烝烵焋焧焯煄煑照煮煰熧熫熷燝燥燪燭燳爥爪爫爭爼牂牐牸犆犳状狀狆狣狰狾猔猘猙猣猪猹獉獐玆珇珍珎珘珠琖琢琸瑑瑧瑵瑼璋璏璔璪璻瓆瓉瓒瓚瓡甀甃甄甎甑甽甾畛畤畷疐疛疭疰疷疹疻痄症痓痔痣痮瘃瘇瘈瘬瘲瘴瘵癥皁皂皟皱皶皺皻皽盅盏盞盩直眐眕眝眞真眥眦眨眹眾着睁睜睭睵瞔瞕瞩瞻瞾矚矠知矪矰矷矺砋砓砖砟砦砧砫砸硃硳硺硾碂碡碪磔磗磚磫磳礃礈礋礩祉祌祑祖祗祚祝祩祬祭祯祽禃禌禎禔禚禛禶秄种秓秖租秨秩秭秶秷秼稓稕稙稚稡種稯稵稹稺穉穛穝穱窀窄窋窒窡窧竃竈站竚章竱竹竺笁笊笍笜笫笮筑筗筝筫筯筰箃箌箏箒箚箤箦箴箸篆築篜篧篫篴篸篹簀簉簗簪簮簻籀籈籑籒籕籗籦籫籱籷籽粀粂粍粘粙粢粥粧粻粽糉糌糚糟糭糳糽紂紎紖紙紥紩紫紮紵紸紾終組絊絑絷絼綕綜綧綴綻緃緅緇総緕緫緵緻縂縋縐縝縡縥縦縱縳縶總繇繌繒繓織繜繤纂纃纉纗纘纣纵纸纻纼组织终绉综绽缀缁缒缜缯缴缵罀罇罜罩罪罬置罾羄翐翟翥翪者耔耫聀聄聇职職肁肇肈肘肢肫肿胀胄胏胑胔胗胙胝胾脀脂脏脧脹腏腙腞腫膇膞膣膱膼臓臜臟臢臧自至致臸臻舟舯舳舴艁芓芖芝芧芷苎苲苴茁茈茊茋茝茡茱茲茽茿荘荢荮莇莊莋菆菑菚菷菹葃葄葅著葘葤葬葴葼蒃蒖蒩蒸蓁蓗蓙蓫蓻蔁蔗蔠蔵蔶蕏蕞薝薻薽藏藢藸藻蘵蘸虥虦虴虸蚛蚤蚱蚻蛀蛅蛛蛭蛰蜇蜘蜙蜡蝫蝬螤螫螲螽蟄蟅蟑蟕蟙蟤蠈蠋蠌蠗蠩蠾蠿衆衳衶衷衹衼袏袗袟袠袩袾装裖裝製褚褶襈襍襗襢襧襵襸覙覟覱觗觜觯觰觶訨訰診註証訾訿詀詋詐詔詛詝詟詹誅誌誫諁諄諈諍諎諏諑諥諮諯諸謅謫謮謶謺譄譇證譐譔譖譗譟譧譫譸讁讃讋讚讝证诅识诈诊诌诏诛诤诪诸诹诼调谆谘谪谮谵豑豒豬豵豸貞責貭貯貲資賊賍賑賘賙賛質賬賳賺賾贄贅贈贊贓贜贞责账质贮贼贽赀赃资赈赒赘赚赜赞赠赭走赱赵赼趈趑趙趦趮趱趲足趾跓跖跦跩跱踤踨踪踬踭踯踵踷蹔蹠蹢蹤蹧蹱躁躅躑躓躜躦軄転軫軴軸軹輈載輊輒輖輙輚輜輺輾轃轉轍轏轧转轴轵轸载轾辀辄辎辗辙辠辴迍这迣迬迮追逐這造逫週遉遧遭遮遵邅邹邾郅郑郮郰鄑鄒鄟鄣鄫鄭鄹鄼酂酇酌酎酔酙酨酯酻醆醉醊醡醩重釗針釞釨鈡鈭鈼鉁鉆鉊鉒鉔鉙鉦銂銌銍銖銸銺銿鋕鋜鋥鋳鋴鋷錊錐錙錚錣錱錺錾鍐鍘鍣鍺鍼鍾鍿鎡鎭鎮鏃鏨鏱鏳鐏鐕鐘鐟鐯鐲鑁鑄鑆鑕鑚鑽鑿钃针钊钟钲钻铚铡铢铮铸锃锗锥锧锱锺镃镇镞镯长閘閚闸阯阵阻阼陟陣陬陼障隲隹隻雉雑雜雥霅震霌霑靕靻鞐韴頾頿顓颛颭飐飦飳飵餦饌饘饡馔馵馶馽駋駎駐駔駗駤駯駲騅騆騌騣騭騶騺騿驇驏驙驟驵驺驻骓骔骘骤髒髭髽鬃鬇鬉鬒鬵鬷魙魳魸鮓鮡鮢鮺鮿鯑鯔鯞鯫鯮鯯鯺鯼鰂鰦鱁鱄鱆鱒鱡鱣鱵鲊鲗鲝鲭鲰鲻鳟鳣鳷鴆鴊鴙鴤鴲鴸鵃鵤鵫鵻鶅鷓鷙鷟鷷鸀鸅鸇鸩鸷鸼鹧鹯麆麈麞黀黰黵黹鼄鼅鼌鼒鼡鼨齄齇齋齍齚齜齰齱齺龇]',
    \ }
endfunction
