import 'package:ere_manager/credit/Data.dart';

class Str {
  String lang;

  final values = {
    '한국어': {
      'duringAutoLogin': '자동로그인중...',
      'loginSuccess': '로그인되었습니다.',
      'autoLoginError': '자동로그인 정보가 없습니다.',
      'creditsChecklist': '학점 체크리스트',
      'lectureBookLoan': '수업 교재 대여',
      'logout': '로그아웃',
      'logoutSuccess': '로그아웃되었습니다.',
      'editPersonalData': '개인정보 수정',
      'editPersonalDataDetail': '개인정보를 수정한 후 [수정] 버튼을 눌러주세요.',
      'name': '이름',
      'studentID': '학번',
      'phoneNumber': '연락처',
      'edit': '수정',
      'editSuccess': '개인정보를 수정했습니다.',
      'cancel': '취소',
      'signOut': '회원탈퇴',
      'signOutInfo': '회원탈퇴 안내',
      //todo: 에자공 도서관 추가 시 수정
      'signOutDetail':
          '탈퇴할 경우 회원가입 시 제공해주신 개인정보와 함께 학점 체크리스트 백업 데이터, 등록한 교재 정보, 교재 대여 신청 내역 등이 삭제됩니다. 탈퇴를 진행하시겠습니까?',
      'signOutSuccess': '탈퇴처리가 완료되었습니다.',
      'signOutFail': '회원탈퇴 실패',
      'sNumMatchError': '학번을 형식에 맞게 정확히 입력해주세요.',
      'sNumMissError': '학번을 입력해주세요.',
      'downloadSuccess': '서버에서 불러오기 성공',
      'downloadFail': '서버에서 불러오기 실패',
      'uploadSuccess': '서버에 저장 성공',
      'uploadFail': '서버에 저장 실패',
      'loadFail': '불러오기 실패',
      'loadSuccess': '불러오기 성공',
      'totalCredits': '전체 학점',
      'apply': '반영',
      'save': '저장',
      'close': '닫기',
      'foreignLectureCheck': '외국어진행강좌 수강 체크',
      'serverBackup': '서버 백업',
      'serverBackupDetail': '서버에 데이터를 백업하거나 서버로부터 백업 데이터를 내려받을 수 있습니다.',
      'uploadBackup': '서버에 백업',
      'duringUpload': '서버에 백업 중',
      'downloadBackup': '백업 데이터 내려받기',
      'duringDownload': '백업 데이터 내려받는 중',
      'life': '생명존중(자살예방)교육 이수 (16학번 이후 필수)',
      'changeSNumInfo': '학번 수정 안내',
      'changeSNumDetail':
          '학번 설정을 수정할 경우 과목들을 체크 및 추가해 놓은 데이터가 초기화됩니다.\n그래도 괜찮으시면 [확인] 버튼을 눌러주세요.',
      'ok': '확인',
      'changeMajorInfo': '전공과정 변경 안내',
      'changeMajorDetail':
          '전공과정 변경 시 과목들을 체크 및 추가해 놓은 데이터가 초기화됩니다.\n전공과정 변경 후 다시 설정해 주세요.',
      'saveSuccess': '저장되었습니다.',
      'saveFail': '저장 실패',
      'info': '도움말',
      'infoDetail':
          "본 앱은 에자공 학부생 개인이 만든 것으로 각 항목들은 정확하지 않을 수 있습니다. 마이스누 > 학사정보 > 졸업 > 졸업사정(자가진단)처리 전공내역에서 '이수규정 및 내규조회' 및 졸업시뮬레이션 또는 학과사무실에 문의를 통해 정확한 졸업 요건을 확인하시기 바랍니다.\n"
              "학과사무실: 02-880-7219",
      'ereLink': '에너지자원공학과 홈페이지 링크',
      'studentIDHint': "ex) 16학번이면 '16'입력",
      'studentIDError': '학번은 숫자 2자리로 입력해주세요.',
      'major': '전공',
      'foreignLectureRegulation': '1과목 이상의 전공을 포함해 3과목 이상 외국어진행강좌(대학영어 제외) 수강',
      'culture': '교양',
      'forLecNameHint': '과목명을 입력하세요.',
      'add': '추가',
      'delete': '삭제',
      'addForLecSuccess': '외국어진행강좌가 추가되었습니다.',
      'addForLecFail': '과목의 종류와 과목명을 입력해주세요.',
      'deleteAddedLectureSuccess': '과목이 삭제되었습니다.',
      'freeLectureNameHint': '과목명 입력',
      'freeLectureCreditsHint': '학점 입력',
      'addAddedLectureSuccess': '과목이 추가되었습니다.',
      'creditsMissError': '학점을 반드시 입력해주세요.',
      'edit2': '편집',
      'credits': '학점',
      'lectureBookRequestChange': '교재 신청 내역에 변동이 생겼습니다.',
      'lectureBookList': '수업 교재 목록',
      'myPage': '마이페이지',
      'number': '번호',
      'lectureBookTitle': '교재명',
      'author': '저자',
      'lecture': '과목',
      'owner': '제공자',
      'option': '방식',
      'lectureBookRequestToMe': '나에게 온 신청',
      'receiver': '신청자',
      'noLectureBookRequestToMe': '받은 신청이 없습니다.',
      'lectureBookRequestFromMe': '내가 보낸 신청',
      'noLectureBookRequestFromMe': '보낸 신청이 없습니다.',
      'lectureBookRegister': '교재 등록',
      'lectureBookOptionHint': "'대여' 또는 '양도' 입력",
      'barcodeScanError': '국립중앙도서관에 등록정보가 없습니다. 양식을 직접 입력해주세요.',
      'register': '등록',
      'lectureBookRegisterError': '빈칸을 모두 입력해주세요.',
      'lectureBookRegisterSuccess': '교재가 등록되었습니다.',
      'accepted': '승인 완료',
      'accept': '승인',
      'lectureBookRequestAcceptDetail':
          '승인하면 신청자에게 연락처가 전달되며, 동일 교재에 대한 다른 신청들은 반려 처리됩니다. 계속하시겠습니까?',
      'acceptSuccess': '승인되었습니다.',
      'rejected': '반려',
      'message': '문자 보내기',
      'rejected2': '반려 대기',
      'rejectedDetail':
          '동일 교재에 대해 다른 신청자가 승인되어 반려된 신청입니다. [확인]을 누르면 목록에서 삭제됩니다.',
      'request': '신청',
      'duplicateRequestError': '이미 신청한 교재입니다.',
      'lectureBookDeactiveError': '신청이 비활성화된 교재입니다.',
      'login': '로그인/회원가입',
      'loginFail': '로그인 실패: 입력 정보를 확인한 후 다시 시도해주세요.',
      'agreementInfo': '개인정보 수집 동의',
      'agreementCheck': '상기 내용을 확인했으며 개인정보 제공에 동의합니다.',
      'continue': '계속',
    },
    'English': {
      'duringAutoLogin': 'Logging in automatically...',
      'loginSuccess': 'Succeeded to log in.',
      'autoLoginError': 'There is no data for auto login.',
      'creditsChecklist': 'Credits checklist',
      'lectureBookLoan': 'Textbook loan',
      'logout': 'Log out',
      'logoutSuccess': 'Logout success',
      'editPersonalData': 'Edit personal data',
      'editPersonalDataDetail': 'Edit your personal data and press [Edit].',
      'name': 'Name',
      'studentID': 'Student ID',
      'phoneNumber': 'Phone number',
      'edit': 'Edit',
      'editSuccess': 'Personal data has been edited.',
      'cancel': 'Cancel',
      'signOut': 'Sign out',
      'signOutInfo': 'Sign out Info',
      //todo: 에자공 도서관 추가 시 수정
      'signOutDetail':
          'If you sign out, all the personal data you provided when you signed in and the data of your credits checklist backup, the textbooks you registered, and the textbook loan requests related with you will be deleted. Do you want to sign out?',
      'signOutSuccess': 'Succeeded to sign out.',
      'signOutFail': 'Failed to sign out.',
      'sNumMatchError': 'Please type in your student ID correctly.',
      'sNumMissError': 'Please type in your student ID.',
      'downloadSuccess': 'Succeeded to load your backup data from the server.',
      'downloadFail': 'Failed to load your backup data from the server.',
      'uploadSuccess': 'Succeeded to store your backup data to the server.',
      'uploadFail': 'Failed to store your backup data to the server.',
      'loadFail': 'Failed to load data.',
      'loadSuccess': 'Succeeded to load data.',
      'totalCredits': 'Total\ncredits',
      'apply': 'Apply',
      'save': 'Save',
      'close': 'Close',
      'foreignLectureCheck': 'Lectures with\nforeign language',
      'serverBackup': 'Backup to server',
      'serverBackupDetail': 'You can upload or download your backup data.',
      'uploadBackup': 'Upload backup',
      'duringUpload': 'Uploading backup',
      'downloadBackup': 'Download backup',
      'duringDownload': 'Downloading backup',
      'life':
          'Respect for life(suicide prevention) education\n(mandatory for students who entered since then 2016.',
      'changeSNumInfo': 'Change student ID Info',
      'changeSNumDetail':
          'If you change your student ID, all the data of credits checklist you have made will be reset.\nIf it is OK, press [OK].',
      'ok': 'OK',
      'changeMajorInfo': 'Change major course Info',
      'changeMajorDetail':
          'If you change your major course, all the data of credits checklist you have made will be reset.\nPlease set up them again after changing your major course.',
      'saveSuccess': 'Succeeded to save the data.',
      'saveFail': 'Failed to save the data.',
      'info': 'Info',
      'infoDetail':
          "This app is made by a student so each item may not be correct. Please check correct regulations by 'Search Regulations' at My SNU > Academic Affairs > Graduation > Graduation Assessment(Self-diagnosis) Processing Major Details and Graduation Rqmt Simulation or inquiring the ERE department office.\n"
              "ERE department office: 02-880-7219",
      'ereLink': 'ERE homepage',
      'studentIDHint': "ex) Type in '16' for '2016'",
      'studentIDError': 'Please type in a integer with 2 digits.',
      'major': 'Major',
      'foreignLectureRegulation':
          'More than 3 courses with foreign language including at least 1 major course(except College English)',
      'culture': 'General',
      'forLecNameHint': 'Name of course',
      'add': 'Add',
      'delete': 'Delete',
      'addForLecSuccess': 'Succeeded to add the course.',
      'addForLecFail': 'Please type in the type and the name of the course.',
      'deleteAddedLectureSuccess': 'Succeeded to delete the course.',
      'freeLectureNameHint': 'Name',
      'freeLectureCreditsHint': 'Credits',
      'addAddedLectureSuccess': 'Succeeded to add the course.',
      'creditsMissError': 'Please type in the credits of the course.',
      'edit2': 'Edit',
      'credits': 'credits',
      'lectureBookRequestChange':
          'Your textbook loan request has been modified.',
      'lectureBookList': 'Textbook list',
      'myPage': 'My page',
      'number': 'No.',
      'lectureBookTitle': 'Title',
      'author': 'Author',
      'lecture': 'Course',
      'owner': 'Owner',
      'option': 'Option',
      'lectureBookRequestToMe': 'Textbook loan requests to you',
      'receiver': 'Receiver',
      'noLectureBookRequestToMe': 'There is no textbook loan request to you.',
      'lectureBookRequestFromMe': 'Textbook loan requests from you',
      'noLectureBookRequestFromMe':
          'There is no textbook loan request from you.',
      'lectureBookRegister': 'Register textbook',
      'lectureBookOptionHint': "'Rental' or 'Transfer'",
      'barcodeScanError':
          'This textbook has not registered in National Library of Korea. Please fill the form by yourself.',
      'register': 'Register',
      'lectureBookRegisterError': 'Please fill in all the blanks.',
      'lectureBookRegisterSuccess': 'Succeeded to register the textbook.',
      'accepted': 'Accepted',
      'accept': 'Accept',
      'lectureBookRequestAcceptDetail':
          'As accepting the request, your phone number will be sent to the receiver and other requests for the textbook will be rejected. Would you accept the request?',
      'acceptSuccess': 'Succeeded to accept the request.',
      'rejected': 'Rejected',
      'message': 'Text message',
      'rejected2': 'Rejected',
      'rejectedDetail':
          'This request has been rejected because another student has been accepted. The request will be removed from the list as you press [OK].',
      'request': 'Request',
      'duplicateRequestError': 'You have already requested the textbook.',
      'lectureBookDeactiveError': 'The textbook is not available.',
      'login': 'Log in/Sign in',
      'loginFail': 'Failed to log in: Please try again.',
      'agreementInfo': 'Consent to personal information collection',
      'agreementCheck':
          'I verified the above statements and agree to provide personal information.',
      'continue': 'Continue',
    }
  };

  String get duringAutoLogin => values[lang]['duringAutoLogin'];

  String get loginSuccess => values[lang]['loginSuccess'];

  String get autoLoginError => values[lang]['autoLoginError'];

  String get creditsChecklist => values[lang]['creditsChecklist'];

  String get lectureBookLoan => values[lang]['lectureBookLoan'];

  String get logout => values[lang]['logout'];

  String get logoutSuccess => values[lang]['logoutSuccess'];

  String get editPersonalData => values[lang]['editPersonalData'];

  String get editPersonalDataDetail => values[lang]['editPersonalDataDetail'];

  String get name => values[lang]['name'];

  String get studentID => values[lang]['studentID'];

  String get phoneNumber => values[lang]['phoneNumber'];

  String get edit => values[lang]['edit'];

  String get editSuccess => values[lang]['editSuccess'];

  String get cancel => values[lang]['cancel'];

  String get signOut => values[lang]['signOut'];

  String get signOutInfo => values[lang]['signOutInfo'];

  String get signOutDetail => values[lang]['signOutDetail'];

  String get signOutSuccess => values[lang]['signOutSuccess'];

  String get signOutFail => values[lang]['signOutFail'];

  String get sNumMatchError => values[lang]['sNumMatchError'];

  String get sNumMissError => values[lang]['sNumMissError'];

  String get downloadSuccess => values[lang]['downloadSuccess'];

  String get downloadFail => values[lang]['downloadFail'];

  String get uploadSuccess => values[lang]['uploadSuccess'];

  String get uploadFail => values[lang]['uploadFail'];

  String get loadFail => values[lang]['loadFail'];

  String get loadSuccess => values[lang]['loadSuccess'];

  String get totalCredits => values[lang]['totalCredits'];

  String get apply => values[lang]['apply'];

  String get save => values[lang]['save'];

  String get close => values[lang]['close'];

  String get foreignLectureCheck => values[lang]['foreignLectureCheck'];

  String get serverBackup => values[lang]['serverBackup'];

  String get serverBackupDetail => values[lang]['serverBackupDetail'];

  String get uploadBackup => values[lang]['uploadBackup'];

  String get duringUpload => values[lang]['duringUpload'];

  String get downloadBackup => values[lang]['downloadBackup'];

  String get duringDownload => values[lang]['duringDownload'];

  String get life => values[lang]['life'];

  String get changeSNumInfo => values[lang]['changeSNumInfo'];

  String get changeSNumDetail => values[lang]['changeSNumDetail'];

  String get ok => values[lang]['ok'];

  String get changeMajorInfo => values[lang]['changeMajorInfo'];

  String get changeMajorDetail => values[lang]['changeMajorDetail'];

  String get saveSuccess => values[lang]['saveSuccess'];

  String get saveFail => values[lang]['saveFail'];

  String get info => values[lang]['info'];

  String get infoDetail => values[lang]['infoDetail'];

  String get ereLink => values[lang]['ereLink'];

  String get studentIDHint => values[lang]['studentIDHint'];

  String get studentIDError => values[lang]['studentIDError'];

  String get major => values[lang]['major'];

  String get foreignLectureRegulation =>
      values[lang]['foreignLectureRegulation'];

  String get culture => values[lang]['culture'];

  String get forLecNameHint => values[lang]['forLecNameHint'];

  String get add => values[lang]['add'];

  String get delete => values[lang]['delete'];

  String get addForLecSuccess => values[lang]['addForLecSuccess'];

  String get addForLecFail => values[lang]['addForLecFail'];

  String get deleteAddedLectureSuccess =>
      values[lang]['deleteAddedLectureSuccess'];

  String get freeLectureNameHint => values[lang]['freeLectureNameHint'];

  String get freeLectureCreditsHint => values[lang]['freeLectureCreditsHint'];

  String get addAddedLectureSuccess => values[lang]['addAddedLectureSuccess'];

  String get creditsMissError => values[lang]['creditsMissError'];

  String get edit2 => values[lang]['edit2'];

  String get credits => values[lang]['credits'];

  String get lectureBookRequestChange =>
      values[lang]['lectureBookRequestChange'];

  String get lectureBookList => values[lang]['lectureBookList'];

  String get myPage => values[lang]['myPage'];

  String get number => values[lang]['number'];

  String get lectureBookTitle => values[lang]['lectureBookTitle'];

  String get author => values[lang]['author'];

  String get lecture => values[lang]['lecture'];

  String get owner => values[lang]['owner'];

  String get option => values[lang]['option'];

  String get lectureBookRequestToMe => values[lang]['lectureBookRequestToMe'];

  String get receiver => values[lang]['receiver'];

  String get noLectureBookRequestToMe =>
      values[lang]['noLectureBookRequestToMe'];

  String get lectureBookRequestFromMe =>
      values[lang]['lectureBookRequestFromMe'];

  String get noLectureBookRequestFromMe =>
      values[lang]['noLectureBookRequestFromMe'];

  String get lectureBookRegister => values[lang]['lectureBookRegister'];

  String get lectureBookOptionHint => values[lang]['lectureBookOptionHint'];

  String get barcodeScanError => values[lang]['barcodeScanError'];

  String get register => values[lang]['register'];

  String get lectureBookRegisterError =>
      values[lang]['lectureBookRegisterError'];

  String get lectureBookRegisterSuccess =>
      values[lang]['lectureBookRegisterSuccess'];

  String get accepted => values[lang]['accepted'];

  String get accept => values[lang]['accept'];

  String get lectureBookRequestAcceptDetail =>
      values[lang]['lectureBookRequestAcceptDetail'];

  String get acceptSuccess => values[lang]['acceptSuccess'];

  String get rejected => values[lang]['rejected'];

  String get message => values[lang]['message'];

  String get rejected2 => values[lang]['rejected2'];

  String get rejectedDetail => values[lang]['rejectedDetail'];

  String get request => values[lang]['request'];

  String get duplicateRequestError => values[lang]['duplicateRequestError'];

  String get lectureBookDeactiveError =>
      values[lang]['lectureBookDeactiveError'];

  String get login => values[lang]['login'];

  String get loginFail => values[lang]['loginFail'];

  String get agreementInfo => values[lang]['agreementInfo'];

  String get agreementCheck => values[lang]['agreementCheck'];

  String get continueStr => values[lang]['continue'];

  String translate(String text) {
    if (lang != '한국어')
      switch (text) {
        case EREOnly:
          return 'Main major in ERE';
        case EREnOther:
          return 'Main major in ERE +\ndouble major/minor in other';
        case OthernERE:
          return 'Main major in other +\ndouble major in ERE';
        case OthernSubERE:
          return 'Main major in other +\nminor in ERE';
        case '전공':
          return 'Major';
        case '전공필수':
          return 'Required courses of major';
        case '교양':
          return 'General Education';
        case '그 외':
          return 'Other';
        case '학문의 기초':
          return 'Academic Foundations';
        case '핵심교양':
          return 'Core of General Education';
        case '학문의 세계(2개 영역 이상)':
          return 'Worlds of Knowledge(more than 2 areas)';
        case '학문의 세계(3개 영역 이상)':
          return 'Worlds of Knowledge(more than 3 areas)';
        case '공대 사회/창의성':
          return 'Courses for Entrepreneurship/Creativity of College of Engineering';
        case '전공선택필수':
          return 'Required elective courses of major';
        case '전공선택':
          return 'Elective courses of major';
        case '공대 타학과개론':
          return 'Introduction of other engineering major';
        case '사고와 표현':
          return 'Critical Thinking and Writing';
        case '대학영어 또는 고급영어':
          return 'College English or Advanced English';
        case '외국어 2개 교과목\n    (TEPS 900점 이하 영어 1과목 필수)':
          return '2 Foreign Languages\n    (at least 1 English course for students with a TEPS score of 900 and below)';
        case '외국어 2개 교과목\n    (TEPS 900점(New TEPS 525점) 이하 영어 1과목 필수)':
          return '2 foreign languages\n    (at least 1 English for students with a TEPS score of 900(New TEPS score of 525) and below)';
        case '수량적 분석과 추론':
          return 'Mathematical Sciences';
        case '과학적 사고와 실험':
          return 'Natural Sciences';
        case '컴퓨터와 정보 활용':
          return 'Computer and Information Science';
        case '사회성 교과목군 or 인간과 사회 영역':
          return 'Courses for Entrepreneurship or Humans and Society';
        case '창의성 교과목군 or 문화와 예술 영역':
          return 'Courses for Creativity or Culture and Art';
        case '문학과 예술':
          return 'Literature and Art';
        case '사회와 이념':
          return 'Society and Ideology';
        case '언어와 문학':
          return 'Language and Literature';
        case '문화와 예술':
          return 'Culture and Art';
        case '역사와 철학':
          return 'History and Philosophy';
        case '정치와 경제':
          return 'Politics and Economy';
        case '인간과 사회':
          return 'Human and Society';
        case '과학과 기술 글쓰기':
          return 'Writing in Science & Technology';
        case '대학국어':
          return 'College Korean';
        case '대학 글쓰기 1':
          return 'College Writing 1';
        case '대학 글쓰기 2: 과학기술 글쓰기':
          return 'College Writing 2: Writing in Science & Technology';
        case '(고급)수학 및 연습1':
        case '(고급)수학 및 연습 1':
          return '(Honor) Calculus (and Practice) 1';
        case '(고급)수학 및 연습2':
        case '(고급)수학 및 연습 2':
          return '(Honor) Calculus (and Practice) 2';
        case '(고급)수학 1':
          return '(Honor) Calculus 1';
        case '(고급)수학연습 1':
          return '(Honor) Calculus Practice 1';
        case '(고급)수학 2':
          return '(Honor) Calculus 2';
        case '(고급)수학연습 2':
          return '(Honor) Calculus Practice 2';
        case '수학 1과 수학연습 1':
          return 'Calculus 1 and Calculus Practice 1';
        case '수학 2와 수학연습 2':
          return 'Calculus 2 and Calculus Practice 2';
        case '공학수학1':
        case '공학수학 1':
          return 'Engineering Mathematics 1';
        case '공학수학2':
        case '공학수학 2':
          return 'Engineering Mathematics 2';
        case '(고급)물리학1(물리의 기본1)':
        case '(고급)물리학 1(물리의 기본 1)':
          return '(Honor) (Foundation of) Physics 1';
        case '물리학실험1':
        case '물리학실험 1':
          return 'Physics Lab.1';
        case '(고급)물리학2(물리의 기본2)':
        case '(고급)물리학 2(물리의 기본 2)':
          return '(Honor) (Foundation of) Physics 2';
        case '물리학실험2':
        case '물리학실험 2':
          return 'Physics Lab.2';
        case '물리학':
          return 'Physics';
        case '물리학실험':
          return 'Physics Lab.';
        case '화학1':
        case '화학 1':
          return 'Chemistry 1';
        case '화학1(화학의 기본1)':
          return '(Foundation of) Chemistry 1';
        case '화학실험1':
        case '화학실험 1':
          return 'Chemistry Lab.1';
        case '화학2':
        case '화학 2':
          return 'Chemistry 2';
        case '화학2(화학의 기본2)':
          return '(Foundation of) Chemistry 2';
        case '화학실험2':
        case '화학실험 2':
          return 'Chemistry Lab.2';
        case '화학':
          return 'Chemistry';
        case '화학실험':
          return 'Chemistry Lab.';
        case '생물학1':
        case '생물학 1':
          return 'Biology 1';
        case '생물학실험1':
        case '생물학실험 1':
          return 'Biology Lab.1';
        case '생물학2':
        case '생물학 2':
          return 'Biology 2';
        case '생물학실험2':
        case '생물학실험 2':
          return 'Biology Lab.2';
        case '생물학':
          return 'Biology';
        case '생물학실험':
          return 'Biology Lab.';
        case '통계학':
          return 'Statistics';
        case '통계학실험':
          return 'Statistics Lab.';
        case '지구시스템과학':
          return 'Earth System Science';
        case '지구시스템과학실험':
          return 'Earth System Science Lab.';
        case '컴퓨터의 개념 및 실습':
          return 'Digital Computer Concept and Practice';
        case '에너지자원과미래':
          return 'Energy Resources and Future';
        case '에너지자원공학의이해':
          return 'Understanding Energy Resources Engineering';
        case '에너지자원공학실습':
          return 'Energy Resources Engineering Practice';
        case '응용자원지질':
          return 'Applied Resources Geometry';
        case '에너지자원수치해석':
          return 'Energy Resources Numerical Analysis';
        case '시추공학':
          return 'Drilling Engineering';
        case '신재생에너지':
          return 'Renewable Energy';
        case '응용지구화학':
          return 'Applied Geochemistry';
        case '에너지환경공학':
          return 'Energy and Environmental Engineering';
        case '에너지자원역학':
          return 'Energy Resources Dynamics';
        case '에너지자원재료역학':
          return 'Energy Resources Material Dynamics';
        case '에너지환경기술경영':
          return 'Energy and Environmental Technology Management';
        case '지구물리공학':
          return 'Geophysical Engineering';
        case '에너지자원열역학':
          return 'Energy Resources Thermodynamics';
        case '에너지자원유체역학':
          return 'Energy Resources Fluid Dynamics';
        case '에너지자원지구화학':
          return 'Energy Resources Geochemistry';
        case '탄성파탐사':
          return 'Seismic Profiling';
        case '암석역학및실험':
          return 'Rock Mechanics and Experiments';
        case '석유가스공학및실험':
          return 'Petroleum and Gas Engineering and Experiments';
        case '자원처리공학':
          return 'Resource Processing Engineering';
        case '자원공학실습':
          return 'Resource Engineering Practice';
        case '자원공학설계':
          return 'Resource Engineering Design';
        case '대여':
          return 'Rental';
        case '양도':
          return 'Transfer';
        default:
          return text;
      }
    else
      switch (text) {
        case 'Major':
          return '전공';
        case 'General':
        case 'General Education':
          return '교양';
        case 'Rental':
        case 'rental':
          return '대여';
        case 'Transfer':
        case 'transfer':
          return '양도';
        default:
          return text;
      }
  }
}
