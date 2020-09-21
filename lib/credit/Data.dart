import 'package:ere_manager/credit/CreditManager.dart';

const OFF = false;
const ON = true;

//전공과정 변경 처리를 위한 상수
const EREOnly = '에자공 주전공';
const EREnOther = '에자공 주전공, 타학과 복수/부전공';
const OthernERE = '타학과 주전공, 에자공 복수전공';
const OthernSubERE = '타학과 주전공, 에자공 부전공';

//클래스 구분을 위한 상수 코드
const LECTURE_TYPE = 0;
const LECTURE_FIELD = 1;
const LECTURE_GROUP = 2;
const LECTURE_WORLD = 3;
const LECTURE = 4;
const FREE_LECTURE = 5;
const ADDED_LECTURE = 6;

//LectureType
var culture = CreditManager(LECTURE_TYPE, '교양', 40);
var major = CreditManager(LECTURE_TYPE, '전공', 62);
var normal = CreditManager(LECTURE_TYPE, '그 외', 28);

//LectureField
var culture_basic = CreditManager(LECTURE_FIELD, '학문의 기초', 34);
var keyCulture = CreditManager(LECTURE_FIELD, '핵심교양', 9);
var culture_world = CreditManager(LECTURE_FIELD, '학문의 세계(2개 영역 이상)', 6);
var culture_world_sin20 = CreditManager(LECTURE_FIELD, '학문의 세계(3개 영역 이상)', 12); //20학번 이후
var culture_engineering = CreditManager(LECTURE_FIELD, '공대 사회/창의성', 6);
var major_necessary = CreditManager(LECTURE_FIELD, '전공필수', 19);
var major_optNec = CreditManager(LECTURE_FIELD, '전공선택필수', 9);
var major_optional = CreditManager(LECTURE_FIELD, '전공선택', 40);
var major_optOrNec = CreditManager(LECTURE_FIELD, '전공선택, 전공선택필수', 3); //15학번 이전 복수/부전공을 위한 항목
var major_other = CreditManager(LECTURE_FIELD, '공대 타학과개론', 3);

//LectureGroup
var thiExp = CreditManager(LECTURE_GROUP, '사고와 표현', 3);
var foreign = CreditManager(LECTURE_GROUP, '외국어 2개 교과목\n    (TEPS 900점 이하 영어 1과목 필수)', 4);
var numAnaInf = CreditManager(LECTURE_GROUP, '수량적 분석과 추론', 12);
var sciThiExp = CreditManager(LECTURE_GROUP, '과학적 사고와 실험', 12);
var comInfApp = CreditManager(LECTURE_GROUP, '컴퓨터와 정보 활용', 3);
var society = CreditManager(LECTURE_GROUP, '사회성 교과목군 or 인간과 사회 영역', 3);
var creativity = CreditManager(LECTURE_GROUP, '창의성 교과목군 or 문화와 예술 영역', 3);

//LectureWorld
var litArt = CreditManager(LECTURE_WORLD, '문학과 예술');
var socIde = CreditManager(LECTURE_WORLD, '사회와 이념');
var lenLit = CreditManager(LECTURE_WORLD, '언어와 문학');
var culArt = CreditManager(LECTURE_WORLD, '문화와 예술');
var hisPhi = CreditManager(LECTURE_WORLD, '역사와 철학');
var polEco = CreditManager(LECTURE_WORLD, '정치와 경제');
var humSoc = CreditManager(LECTURE_WORLD, '인간과 사회');

//Lecture
var sciEngWri = CreditManager(LECTURE, '과학과 기술 글쓰기', null, 3);
var korean = CreditManager(LECTURE, '대학국어', null, 3);
var colWri1 = CreditManager(LECTURE, '대학 글쓰기 1', null, 2);
var colWri2 = CreditManager(LECTURE, '대학 글쓰기 2: 과학기술 글쓰기', null, 2);
var math1 = CreditManager(LECTURE, '(고급)수학 및 연습 1', null, 3);
var math2 = CreditManager(LECTURE, '(고급)수학 및 연습 2', null, 3);
var mathPra1 = CreditManager(LECTURE, '(고급)수학연습 1', null, 1);
var mathPra2 = CreditManager(LECTURE, '(고급)수학연습 2', null, 1);
var engMat1 = CreditManager(LECTURE, '공학수학 1', null, 3);
var engMat2 = CreditManager(LECTURE, '공학수학 2', null, 3);
var physics1 = CreditManager(LECTURE, '(고급)물리학 1(물리의 기본 1)', null, 3);
var phyExp1 = CreditManager(LECTURE, '물리학실험 1', null, 1);
var physics2 = CreditManager(LECTURE, '(고급)물리학 2(물리의 기본 2)', null, 3);
var phyExp2 = CreditManager(LECTURE, '물리학실험 2', null, 1);
var physics = CreditManager(LECTURE, '물리학', null, 3);
var phyExp = CreditManager(LECTURE, '물리학실험', null, 1);
var chemistry1 = CreditManager(LECTURE, '화학 1', null, 3);
var cheExp1 = CreditManager(LECTURE, '화학실험 1', null, 1);
var chemistry2 = CreditManager(LECTURE, '화학 2', null, 3);
var cheExp2 = CreditManager(LECTURE, '화학실험 2', null, 1);
var chemistry = CreditManager(LECTURE, '화학', null, 3);
var cheExp = CreditManager(LECTURE, '화학실험', null, 1);
var biology1 = CreditManager(LECTURE, '생물학 1', null, 3);
var bioExp1 = CreditManager(LECTURE, '생물학실험 1', null, 1);
var biology2 = CreditManager(LECTURE, '생물학 2', null, 3);
var bioExp2 = CreditManager(LECTURE, '생물학실험 2', null, 1);
var biology = CreditManager(LECTURE, '생물학', null, 3);
var bioExp = CreditManager(LECTURE, '생물학실험', null, 1);
var statistics = CreditManager(LECTURE, '통계학', null, 3);
var staExp = CreditManager(LECTURE, '통계학실험', null, 1);
var earSysSci = CreditManager(LECTURE, '지구시스템과학', null, 3);
var earSysSciExp = CreditManager(LECTURE, '지구시스템과학실험', null, 1);
var computer = CreditManager(LECTURE, '컴퓨터의 개념 및 실습', null, 3);
var eneResFut = CreditManager(LECTURE, '에너지자원과미래', null, 2);
var eneUnd = CreditManager(LECTURE, '에너지자원공학의이해', null, 1);
var enePra = CreditManager(LECTURE, '에너지자원공학실습', null, 1);
var advResGeo = CreditManager(LECTURE, '응용자원지질', null, 3);
var eneResFigAna = CreditManager(LECTURE, '에너지자원수치해석', null, 3);
var driEng = CreditManager(LECTURE, '시추공학', null, 3);
var newRenEne = CreditManager(LECTURE, '신재생에너지', null, 3);
var advEarChe = CreditManager(LECTURE, '응용지구화학', null, 3);
var eneEcoEng = CreditManager(LECTURE, '에너지환경공학', null, 3);
var eneResDyn = CreditManager(LECTURE, '에너지자원역학', null, 3);
var eneMat = CreditManager(LECTURE, '에너지자원재료역학', null, 3);
var eneEcoTecAdm = CreditManager(LECTURE, '에너지환경기술경영', null, 3);
var earPhyEng = CreditManager(LECTURE, '지구물리공학', null, 3);
var eneThe = CreditManager(LECTURE, '에너지자원열역학', null, 3);
var eneFlu = CreditManager(LECTURE, '에너지자원유체역학', null, 3);
var eneEar = CreditManager(LECTURE, '에너지자원지구화학', null, 3);
var elaExp = CreditManager(LECTURE, '탄성파탐사', null, 3);
var stoDynExp = CreditManager(LECTURE, '암석역학및실험', null, 3);
var oilGasEngExp = CreditManager(LECTURE, '석유가스공학및실험', null, 3);
var resProEng = CreditManager(LECTURE, '자원처리공학', null, 3);
var resEngPra = CreditManager(LECTURE, '자원공학실습', null, 1);
var resEngDes = CreditManager(LECTURE, '자원공학설계', null, 1);

//FreeLecture
var foreignFree = CreditManager(FREE_LECTURE, null, null, 0, foreign, 0);
var litArtFree = CreditManager(FREE_LECTURE, null, null, 0, litArt, 0);
var socIdeFree = CreditManager(FREE_LECTURE, null, null, 0, socIde, 0);
var lenLitFree = CreditManager(FREE_LECTURE, null, null, 0, lenLit, 0);
var culArtFree = CreditManager(FREE_LECTURE, null, null, 0, culArt, 0);
var hisPhiFree = CreditManager(FREE_LECTURE, null, null, 0, hisPhi, 0);
var polEcoFree = CreditManager(FREE_LECTURE, null, null, 0, polEco, 0);
var humSocFree = CreditManager(FREE_LECTURE, null, null, 0, humSoc, 0);
var socFree = CreditManager(FREE_LECTURE, null, null, 0, society, 0);
var creFree = CreditManager(FREE_LECTURE, null, null, 0, creativity, 0);
var optFree = CreditManager(FREE_LECTURE, null, null, 0, major_optional, 0);
var othFree = CreditManager(FREE_LECTURE, null, null, 0, major_other, 0);
var norFree = CreditManager(FREE_LECTURE, null, null, 0, normal, 0);
var majorOptOrNecFree = CreditManager(FREE_LECTURE, null, null, 0, major_optOrNec, 0);
