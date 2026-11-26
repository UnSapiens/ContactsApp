unit uConsts;

interface

resourcestring
  // Параметры конфигурационного файла
  cConfigFileName     = 'config.ini';
  cIniSectionDb       = 'Database';
  cIniKeyServer       = 'Server';
  cIniKeyDatabase     = 'Database';
  cIniKeyUserName     = 'UserName';
  cIniKeyPassword     = 'Password';
  cIniKeyCharset      = 'CharacterSet';

  cDefaultServer      = 'localhost';
  cDefaultRelDbPath   = '..\..\..\db\contacts.fdb';
  cDefaultUserName    = 'SYSDBA';
  cDefaultPassword    = 'masterkey';
  cDefaultCharset     = 'UTF8';

  // Заголовки окон
  cAppTitle             = 'Справочник людей и контактов';
  cAddPersonTitle       = 'Добавление человека';
  cAddContactTitle      = 'Добавление контакта';

  // Главная форма: фильтры и панели
  cLblGender            = 'Пол';
  cLblFioFilter         = 'ФИО (от 2 символов)';
  cLblContactFilter     = 'Контакт (от 4 символов)';
  cLblAge               = 'Возраст';
  cBtnSearch            = 'Найти';
  cBtnReset             = 'Сбросить';
  cLblPersonsTitle      = 'Люди';
  cBtnAddPerson         = 'Добавить человека';
  cLblContactsTitle     = 'Контакты выбранного лица';
  cBtnAddContact        = 'Добавить контакт';

  // Выпадающие списки пола
  cGenderAll            = 'Все';
  cGenderMale           = 'Мужской';
  cGenderFemale         = 'Женский';

  // Заголовки колонок таблиц
  cColLastName          = 'Фамилия';
  cColFirstName         = 'Имя';
  cColMiddleName        = 'Отчество';
  cColGender            = 'Пол';
  cColBirthDate         = 'Дата рожд.';
  cColAge               = 'Возраст';
  cColContactType       = 'Тип контакта';
  cColContactValue      = 'Значение';

  // Формы добавления
  cLblLastName          = 'Фамилия *';
  cLblFirstName         = 'Имя *';
  cLblMiddleName        = 'Отчество';
  cLblGenderReq         = 'Пол *';
  cLblBirthDate         = 'Дата рождения *';
  cLblContactType       = 'Тип контакта *';
  cLblContactValue      = 'Значение *';
  cBtnSave              = 'Сохранить';
  cBtnCancel            = 'Отмена';

  // Сообщения валидации и ошибок БД
  cMsgInvalidAge        = 'Возраст должен быть целым неотрицательным числом.';
  cMsgSelectPersonFirst = 'Сначала выберите человека из списка слева.';
  cMsgReqPersonFields   = 'Поля "Фамилия" и "Имя" обязательны для заполнения.';
  cMsgSelectContactType = 'Выберите тип контакта.';
  cMsgReqContactValue   = 'Введите значение контакта.';
  cMsgValidationErr     =
    'Ошибка проверки данных: проверьте обязательные поля и дату рождения.';
  cMsgInvalidEmail      =
    'Введите корректный Email адрес (например, user@example.com).';
  cMsgDuplicateData     = 'Запись с такими данными уже существует в базе.';
  cMsgDbNotFound        = 'Файл базы данных не найден: ';
  cMsgDbConnectFail     = 'Ошибка подключения к БД (';

implementation

end.
