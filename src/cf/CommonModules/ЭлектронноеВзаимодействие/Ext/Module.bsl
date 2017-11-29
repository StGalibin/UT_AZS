﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Электронное взаимодействие".
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Обрабатывает исключительные ситуации по электронным документам.
//
// Параметры:
//   ВидОперации - Строка - вид операции при которой возникло исключение.
//   ПодробныйТекстОшибки - Строка - описание ошибки.
//   ТекстСообщения - Строка - текст ошибки который выводится в виде сообщения.
//   КодСобытия - Строка - код события, используется для стандартизации иерархии событий.
//                Может принимать значения: "ЭлектронноеВзаимодействие" - Общая подсистема, 
//                                          "ОбменСБанками" - Обмен с банками, 
//                                          "ОбменСКонтрагентами" - Обмен с контрагентами,
//                                          "ОбменССайтами" - Обмен с сайтами, 
//                                          "РегламентныеЗадания" - Регламентные задания, 
//                                          "БизнесСеть" - Бизнес-сеть,
//                                          "ИнтеграцияСЯндексКассой" - Интеграция с Яндекс.Кассой.
//
Процедура ОбработатьОшибку(ВидОперации, ПодробныйТекстОшибки, ТекстСообщения = "", КодСобытия = "ОбменСКонтрагентами") Экспорт
	
	ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОбработатьОшибку(
		ВидОперации, ПодробныйТекстОшибки, ТекстСообщения, КодСобытия);
	
КонецПроцедуры

#Область ОбработчикиСобытийБСП

// См. процедуру РегламентныеЗаданияПереопределяемый.ПриОпределенииНастроекРегламентныхЗаданий.
//
Процедура ПриОпределенииНастроекРегламентныхЗаданий(Настройки) Экспорт
	
	// ОбменСКонтрагентами
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами") Тогда
		
		ФООбменСКонтрагентами = "ИспользоватьОбменЭД";
		
		НоваяСтрока = Настройки.Добавить();
		НоваяСтрока.РегламентноеЗадание = Метаданные.РегламентныеЗадания["ОтправкаЭлектронныхДокументов"];
		НоваяСтрока.ФункциональнаяОпция = Метаданные.ФункциональныеОпции[ФООбменСКонтрагентами];
	
		НоваяСтрока = Настройки.Добавить();
		НоваяСтрока.РегламентноеЗадание = Метаданные.РегламентныеЗадания["ПолучениеЭлектронныхДокументов"];
		НоваяСтрока.ФункциональнаяОпция = Метаданные.ФункциональныеОпции[ФООбменСКонтрагентами];
		
		НоваяСтрока = Настройки.Добавить();
		НоваяСтрока.РегламентноеЗадание = Метаданные.РегламентныеЗадания["ПроверкаНовыхЭлектронныхДокументов"];
		НоваяСтрока.ФункциональнаяОпция = Метаданные.ФункциональныеОпции[ФООбменСКонтрагентами];
		
	КонецЕсли;
	
	// ОбменСБанками
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСБанками") Тогда
		НоваяСтрока = Настройки.Добавить();
		НоваяСтрока.РегламентноеЗадание = Метаданные.РегламентныеЗадания["ЗагрузкаСпискаDirectBank"];
		Если НЕ ОбщегоНазначения.РазделениеВключено() Тогда
			НоваяСтрока.ФункциональнаяОпция = Метаданные.ФункциональныеОпции["ИспользоватьОбменСБанками"];
		КонецЕсли;
		НоваяСтрока.ДоступноВМоделиСервиса = Ложь;
	КонецЕсли;

	// ОбменССайтами
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменССайтами") Тогда
		НоваяСтрока = Настройки.Добавить();
		НоваяСтрока.РегламентноеЗадание = Метаданные.РегламентныеЗадания["ОбменССайтом"];
		НоваяСтрока.ФункциональнаяОпция = Метаданные.ФункциональныеОпции["ИспользоватьОбменССайтом"];
	КонецЕсли;

	// ТорговыеПредложения
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ТорговыеПредложения") Тогда
		НоваяСтрока = Настройки.Добавить();
		НоваяСтрока.РегламентноеЗадание = Метаданные.РегламентныеЗадания["СинхронизацияТорговыхПредложений"];
		НоваяСтрока.ФункциональнаяОпция = Метаданные.ФункциональныеОпции["ИспользоватьОбменБизнесСеть"];
		НоваяСтрока.РаботаетСВнешнимиРесурсами = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Регистрирует обработчики поставляемых данных.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - исходная таблица обработчиков поставляемых данных.
//
Процедура ЗарегистрироватьОбработчикиПоставляемыхДанных(Знач Обработчики) Экспорт
	
	ЕстьОбменСБанками = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСБанками");

	Если ЕстьОбменСБанками Тогда
		МодульОбменСБанками = ОбщегоНазначения.ОбщийМодуль("ОбменСБанками");
		Обработчик = Обработчики.Добавить();
		Обработчик.ВидДанных = "DirectBankList";
		Обработчик.КодОбработчика = "DirectBankList";
		Обработчик.Обработчик = МодульОбменСБанками;
		МодульДополнительныеВнешниеКомпоненты = ОбщегоНазначения.ОбщийМодуль("ДополнительныеВнешниеКомпоненты");
		МодульДополнительныеВнешниеКомпоненты.ЗарегистрироватьОбработчикиПоставляемыхДанных(Обработчики);
	КонецЕсли;
	
КонецПроцедуры

// См. процедуру ПрисоединенныеФайлыПереопределяемый.ПриОпределенииСправочниковХраненияФайлов.
//
Процедура ПриОпределенииСправочниковХраненияФайлов(ТипВладелецФайла, ИменаСправочников) Экспорт
	
	ЕстьОбменСКонтрагентами = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами");

	Если ЕстьОбменСКонтрагентами Тогда
		Если Метаданные.ОпределяемыеТипы.ВладелецПрисоединенныхФайлов.Тип.СодержитТип(ТипВладелецФайла) Тогда
			ЕстьОсновнойСправочник = Ложь;
			МассивКлючейКУдалению = Новый Массив;
			Для Каждого КлючИЗначение Из ИменаСправочников Цикл
				Если Метаданные.Справочники.Найти(КлючИЗначение.Ключ) = Неопределено Тогда
					МассивКлючейКУдалению.Добавить(КлючИЗначение.Ключ);
				Иначе
					Если КлючИЗначение.Значение = Истина Тогда
						ЕстьОсновнойСправочник = Истина;
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			Для Каждого Ключ Из МассивКлючейКУдалению Цикл
				ИменаСправочников.Удалить(Ключ);
			КонецЦикла;
			ИменаСправочников.Вставить("ЭДПрисоединенныеФайлы", НЕ ЕстьОсновнойСправочник);
		Иначе
			ИменаСправочников.Вставить("ЭДПрисоединенныеФайлы", Ложь);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// См. процедуру РаботаСФайламиПереопределяемый.ПриОпределенииНастроек.
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	
	ЕстьОбменСКонтрагентами = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами");

	Если ЕстьОбменСКонтрагентами Тогда
		Настройки.НеОчищатьФайлы.Добавить(Метаданные.Справочники["ЭДПрисоединенныеФайлы"]);
		Настройки.НеСинхронизироватьФайлы.Добавить(Метаданные.Справочники["ЭДПрисоединенныеФайлы"]);
		Настройки.НеВыводитьВИнтерфейс.Добавить(Метаданные.Справочники["ЭДПрисоединенныеФайлы"]);
	КонецЕсли;
	
	ЕстьОбменСБанками = ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСБанками");

	Если ЕстьОбменСБанками Тогда
		Настройки.НеОчищатьФайлы.Добавить(Метаданные.Справочники["СообщениеОбменСБанкамиПрисоединенныеФайлы"]);
		Настройки.НеСинхронизироватьФайлы.Добавить(Метаданные.Справочники["СообщениеОбменСБанкамиПрисоединенныеФайлы"]);
		Настройки.НеВыводитьВИнтерфейс.Добавить(Метаданные.Справочники["СообщениеОбменСБанкамиПрисоединенныеФайлы"]);
	КонецЕсли;

	
КонецПроцедуры

// См. процедуру ЭлектроннаяПодписьПереопределяемый.ПриСозданииФормыПроверкаСертификата.
//
Процедура ПриСозданииФормыПроверкаСертификата(Сертификат, ДополнительныеПроверки, ПараметрыДополнительныхПроверок, СтандартныеПроверки, ВводитьПароль) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСБанками") Тогда
		МодульОбменаСБанками = ОбщегоНазначения.ОбщийМодуль("ОбменСБанками");
		МодульОбменаСБанками.ПриСозданииФормыПроверкаСертификата(
			Сертификат, ДополнительныеПроверки, ПараметрыДополнительныхПроверок, СтандартныеПроверки, ВводитьПароль);
	КонецЕсли;
	
КонецПроцедуры

// Формирование текстового представления рекламы.
//
// Параметры:
//  ДополнительнаяИнформация - Структура - с полями:
//   * Картинка - Картинка - картинка из библиотеки картинок;
//   * Текст - Строка - форматированный текст надписи с навигационными ссылками.
//  МассивСсылок - Массив - список ссылок на объекты.
//
Процедура ПриВыводеНавигационнойСсылкиВФормеОбъектаИБ(ДополнительнаяИнформация, МассивСсылок) Экспорт
	
	Если Не ЗначениеЗаполнено(МассивСсылок) Тогда
		Возврат;
	КонецЕсли;
	
	ИмяПлатежногоПоручения = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяНаличиеОбъектаРеквизитаВПрикладномРешении(
					"ПлатежноеПоручениеВМетаданных");
	
	Если МассивСсылок[0].Метаданные().Имя = ИмяПлатежногоПоручения
		И ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСБанками") Тогда
		
		МодульОбменСБанками = ОбщегоНазначения.ОбщийМодуль("ОбменСБанками");
		МодульОбменСБанками.ПриВыводеНавигационнойСсылкиВФормеОбъектаИБ(ДополнительнаяИнформация, МассивСсылок);
		
	ИначеЕсли ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами") Тогда
		
		МодульОбменСКонтрагентамиКлиентСервер = ОбщегоНазначения.ОбщийМодуль("ОбменСКонтрагентамиКлиентСервер");
		МодульОбменСКонтрагентамиКлиентСервер.ПриВыводеНавигационнойСсылкиВФормеОбъектаИБ(ДополнительнаяИнформация, МассивСсылок);
		
	КонецЕсли;
	
КонецПроцедуры

// Заполнения списка шаблонов для разделенного режима работы.
// См. ОчередьЗаданийПереопределяемый.ПриПолученииСпискаШаблонов().
//
// Параметры:
//  ШаблоныЗаданий - Массив - в параметр следует добавить имена предопределенных
//   неразделенных регламентных заданий, которые должны использоваться в качестве
//   шаблонов для заданий очереди.
//
Процедура ПриПолученииСпискаШаблонов(ШаблоныЗаданий) Экспорт
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами") Тогда
		ШаблоныЗаданий.Добавить("ПолучениеЭлектронныхДокументов");
		ШаблоныЗаданий.Добавить("ОтправкаЭлектронныхДокументов");
		ШаблоныЗаданий.Добавить("ПроверкаНовыхЭлектронныхДокументов");
		ШаблоныЗаданий.Добавить("ПроверкаКонтрагентовБЭД");
	КонецЕсли;
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	// ЭлектронноеВзаимодействие.ОбменССайтами
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменССайтами") Тогда
		ШаблоныЗаданий.Добавить("ОбменССайтом");
	КонецЕсли;
	// Конец ЭлектронноеВзаимодействие.ОбменССайтами
	
	// ЭлектронноеВзаимодействие.ТорговыеПредложения
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ТорговыеПредложения") Тогда
		ШаблоныЗаданий.Добавить("СинхронизацияТорговыхПредложений");
	КонецЕсли;
	// Конец ЭлектронноеВзаимодействие.ТорговыеПредложения
	
КонецПроцедуры

// Заполняет соответствие имен методов их псевдонимам для вызова из очереди заданий.
// См. ОчередьЗаданийПереопределяемый.ПриОпределенииПсевдонимовОбработчиков().
//
// Параметры:
//  СоответствиеИменПсевдонимам - Соответствие - 
//    * Ключ - псевдоним метода, например ОчиститьОбластьДанных.
//    * Значение - имя метода для вызова, например РаботаВМоделиСервиса.ОчиститьОбластьДанных.
//        В качестве значения можно указать Неопределено, в этом случае считается что имя 
//        совпадает с псевдонимом.
//
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами") Тогда
		СоответствиеИменПсевдонимам.Вставить("ПроверкаНовыхЭлектронныхДокументов");
	КонецЕсли;
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	// ЭлектронноеВзаимодействие.ОбменССайтами
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменССайтами") Тогда
		СоответствиеИменПсевдонимам.Вставить("ОбменССайтомСобытия.ЗаданиеВыполнитьОбмен", "ОбменССайтомСобытия.ЗаданиеВыполнитьОбмен");
	КонецЕсли;
	// Конец ЭлектронноеВзаимодействие.ОбменССайтами
	
	// ЭлектронноеВзаимодействие.ТорговыеПредложения
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ТорговыеПредложения") Тогда
		СоответствиеИменПсевдонимам.Вставить("СинхронизацияТорговыхПредложений");
	КонецЕсли;
	// Конец ЭлектронноеВзаимодействие.ТорговыеПредложения	
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСДеревомДанных

// Формирует дерево данных для заполнения прикладным решением.
//
// Параметры:
//  Макет - Макет - Макет с описанием структуры дерева.
//
// Возвращаемое значение:
//  ДеревоЗначений - Дерево документа.
//
Функция ДеревоДокумента(Макет) Экспорт
	
	ВысотаТаблицы = Макет.ВысотаТаблицы;
	ШиринаТаблицы = Макет.ШиринаТаблицы;
	ТаблицаЗначений = Новый ТаблицаЗначений;
	
	Для НомерКолонки = 1 По ШиринаТаблицы Цикл
		ОбластьШапки = Макет.Область(1,НомерКолонки);
		НазваниеКолонки = ОбластьШапки.Текст;
		ТаблицаЗначений.Колонки.Добавить(НазваниеКолонки);
	КонецЦикла;
	
	Для НомерСтроки = 2 По ВысотаТаблицы Цикл
		НоваяСтрока = ТаблицаЗначений.Добавить();
		Для НомерКолонки = 0 По ШиринаТаблицы-1 Цикл
			НоваяСтрока.Установить(НомерКолонки, Макет.Область(НомерСтроки, НомерКолонки + 1).Текст);
		КонецЦикла
	КонецЦикла;
	ТаблицаЗначений.Колонки.Добавить("ПолныйПуть");
	ТаблицаЗначений.Колонки.Сдвинуть("Значение", -6);
	ТаблицаЗначений.Колонки.Сдвинуть("ПолныйПуть", -ШиринаТаблицы);
	КолУровней = 0;
	
	ДеревоЗначений = Новый ДеревоЗначений;
	Для Каждого Колонка Из ТаблицаЗначений.Колонки Цикл
		ДеревоЗначений.Колонки.Добавить(Колонка.Имя);
		Если СтрНайти(Колонка.Имя, "Уровень") > 0 Тогда
			НомерУровня = Число(Сред(Колонка.Имя, 8, 2));
			Если НомерУровня > КолУровней Тогда
				КолУровней = НомерУровня;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ПолныйПуть = "";
	РекурсивноЗаполнитьСтрокиДерева(ДеревоЗначений, 1, КолУровней, ПолныйПуть, ТаблицаЗначений, 0);
	
	Возврат ДеревоЗначений;
	
КонецФункции

// Сохраняет значение в дереве данных
//
// Параметры:
//  Дерево - ДеревоЗначений - дерево данных, в котором необходимо сохранить данные
//  Реквизит - Строка - содержит полный путь к реквизиту
//  Значение - Произвольный - сохраняемое значение
//  КорневойЭлементДерева - Строка - необходимо использовать в случае, если в таблице надо заполнить
//    сложный тип данных (группа, выбор). Например: "Товары.НомерСтроки.Покупатель", Покупатель -
//    является сложным типом данных, тогда КорневойЭлементДерева = "Товары.НомерСтроки".
//
Процедура ЗаполнитьЗначениеРеквизитаВДереве(Дерево, Реквизит, Значение, КорневойЭлементДерева = "") Экспорт
	
	СтрокаДерева = Дерево.Строки.Найти(Реквизит, "ПолныйПуть", Истина);
	СтрокаДерева.Значение = Значение;
	
	МассивРеквизитов = ОбщегоНазначенияКлиентСервер.РазложитьСтрокуПоТочкамИСлэшам(Реквизит);
	Если МассивРеквизитов.Количество() = 1 Тогда
		Возврат;
	КонецЕсли;
	Путь = "";
	Для Каждого Элемент Из МассивРеквизитов Цикл
		Путь = ?(ЗначениеЗаполнено(Путь), Путь + "." + Элемент, Элемент);
		Если СтрНайти(КорневойЭлементДерева, Путь) > 0 Тогда
			Продолжить;
		КонецЕсли;
		СтрокаДерева = Дерево.Строки.Найти(Путь, "ПолныйПуть", Истина);
		Если СтрокаДерева.Признак = "Группа" Тогда
			СтрокаДерева.Значение = Истина;
		ИначеЕсли СтрокаДерева.Признак = "Выбор" Тогда
			ТекИндекс = МассивРеквизитов.Найти(Элемент);
			СтрокаДерева.Значение = МассивРеквизитов[ТекИндекс+1];
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Записывает данные из таблицы значений в дерево значений
//
// Параметры:
//  Дерево - ДеревоЗначений - дерево данных, в котором необходимо сохранить данные
//  ТаблицаДанных - таблицаЗначений - записываемые в дерево данные
//  НазваниеТаблицы - Строка - название таблицы в дереве.
//
Процедура ЗагрузитьТаблицуВДерево(Дерево, ТаблицаДанных, НазваниеТаблицы) Экспорт
	
	СтрокаТаблицы = Дерево.Строки.Найти(НазваниеТаблицы, "ПолныйПуть", Истина);
	НомерСтроки = 0;
	Для Каждого СтрокаДанных Из ТаблицаДанных Цикл
		НомерСтроки = НомерСтроки + 1;
		Если НомерСтроки = 1 Тогда
			ТекСтрока = СтрокаТаблицы.Строки[0];
		Иначе
			ПерваяСтрока = СтрокаТаблицы.Строки[0];
			ТекСтрока = СтрокаТаблицы.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(ТекСтрока, ПерваяСтрока);
			СкопироватьСтрокиДереваДляТаблицыРекурсивно(ТекСтрока, ПерваяСтрока);
		КонецЕсли;
		ТекСтрока.Значение = НомерСтроки;
		Для Каждого Колонка Из ТаблицаДанных.Колонки Цикл
			Если Колонка.Имя = "ДопДанныеПодписанные" ИЛИ Колонка.Имя = "ДопДанныеНеПодписанные" Тогда
				
				СтрокаДопДанных = ТекСтрока.Строки.Найти(ТекСтрока.ПолныйПуть + "." + Колонка.Имя, "ПолныйПуть");
				СтруктураДопДанных = СтрокаДанных[Колонка.Имя];
				
				Если ЗначениеЗаполнено(СтруктураДопДанных) Тогда
					ДобавитьДопДанныеВДерево(
							СтрокаДопДанных,
							СтруктураДопДанных,
							?(Колонка.Имя = "ДопДанныеПодписанные", Истина, Ложь));
				КонецЕсли;
				
				Продолжить;
			КонецЕсли;
			ПолныйПуть = НазваниеТаблицы + ?(Колонка.Имя = "НомерСтроки", ".", ".НомерСтроки.") + Колонка.Имя;
			СтрокаРеквизита = ТекСтрока.Строки.Найти(ПолныйПуть, "ПолныйПуть");
			Если СтрокаРеквизита <> Неопределено Тогда
				Если СтрокаРеквизита.Признак = "Таблица" И НЕ СтрокаДанных[Колонка.Имя] = Неопределено Тогда
					ЗагрузитьТаблицуВДерево(ТекСтрока, СтрокаДанных[Колонка.Имя], ПолныйПуть);
				Иначе
					СтрокаРеквизита.Значение = СтрокаДанных[Колонка.Имя];
				КонецЕсли
			КонецЕсли;
		КонецЦикла
		
	КонецЦикла;
	СтрокаТаблицы.Значение = ТаблицаДанных.Количество();
	
	МассивРеквизитов = ОбщегоНазначенияКлиентСервер.РазложитьСтрокуПоТочкамИСлэшам(НазваниеТаблицы);
	Если МассивРеквизитов.Количество() = 1 Тогда
		Возврат;
	КонецЕсли;
	Путь = "";
	Для Каждого Элемент Из МассивРеквизитов Цикл
		Путь = ?(ЗначениеЗаполнено(Путь), Путь + "." + Элемент, Элемент);
		
		СтрокаДерева = Дерево.Строки.Найти(Путь, "ПолныйПуть", Истина);
		Если СтрокаДерева <> Неопределено Тогда
			Если СтрокаДерева.Признак = "Группа" Тогда
				СтрокаДерева.Значение = Истина;
			ИначеЕсли СтрокаДерева.Признак = "Выбор" Тогда
				ТекИндекс = МассивРеквизитов.Найти(Элемент);
				СтрокаДерева.Значение = МассивРеквизитов[ТекИндекс+1];
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Добавляет строку в таблицу из коллекции свойств
//
// Параметры:
//  Дерево - ДеревоЗначений - дерево данных, в котором необходимо сохранить данные
//  Коллекция - Структура, Выборка, СтрокаТаблицыЗначений - коллекция для сохранения в дереве
//  НазваниеТаблицы - Строка - название таблицы в дереве.
//
Процедура ДобавитьЗаписьВТаблицуДерева(Дерево, Коллекция, НазваниеТаблицы) Экспорт
	
	ШапкаТаблицы = Дерево.Строки.Найти(НазваниеТаблицы, "ПолныйПуть", Истина);
	ШапкаТаблицы.Значение = ?(ЗначениеЗаполнено(ШапкаТаблицы.Значение), ШапкаТаблицы.Значение + 1, 1);
	
	СтруктураКолонок = СтруктураКолонокТаблицыДерева(Дерево, НазваниеТаблицы);
	ЗаполнитьЗначенияСвойств(СтруктураКолонок, Коллекция);
	ПерваяСтрокаДерева = Дерево.Строки.Найти(НазваниеТаблицы + ".НомерСтроки", "ПолныйПуть", Истина);
	
	Если ПустаяСтрока(ПерваяСтрокаДерева.Значение) Тогда
		НоваяСтрока = ПерваяСтрокаДерева;
		НомерСтроки = 1;
	Иначе
		Таблица = Дерево.Строки.Найти(НазваниеТаблицы, "ПолныйПуть", Истина);
		НомерСтроки = Таблица.Строки.Количество() + 1;
		НоваяСтрока = Таблица.Строки.Добавить();
		НоваяСтрока.ПолныйПуть = НазваниеТаблицы + ".НомерСтроки";
		СкопироватьСтрокиДереваДляТаблицыРекурсивно(НоваяСтрока, ПерваяСтрокаДерева);
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ПерваяСтрокаДерева);
	НоваяСтрока.Значение = НомерСтроки;
	
	Для Каждого Элемент Из НоваяСтрока.Строки Цикл
		
		Если НазваниеКолонки(Элемент.ПолныйПуть) = "ДопДанные" Тогда
			Если СтруктураКолонок.Свойство("ДопДанныеПодписанные") Тогда
				ДобавитьДопДанныеВДерево(Элемент, СтруктураКолонок.ДопДанныеПодписанные, Истина);
			КонецЕсли;
			Если СтруктураКолонок.Свойство("ДопДанныеНеПодписанные") Тогда
				ДобавитьДопДанныеВДерево(Элемент, СтруктураКолонок.ДопДанныеНеПодписанные);
			КонецЕсли;
			Продолжить;
		КонецЕсли;
		
		Элемент.Значение = СтруктураКолонок[НазваниеКолонки(Элемент.ПолныйПуть)];
		
	КонецЦикла;
	
	МассивРеквизитов = ОбщегоНазначенияКлиентСервер.РазложитьСтрокуПоТочкамИСлэшам(НазваниеТаблицы);
	Если МассивРеквизитов.Количество() = 1 Тогда
		Возврат;
	КонецЕсли;
	Путь = "";
	Для Каждого Элемент Из МассивРеквизитов Цикл
		Путь = ?(ЗначениеЗаполнено(Путь), Путь + "." + Элемент, Элемент);
		
		СтрокаДерева = Дерево.Строки.Найти(Путь, "ПолныйПуть", Истина);
		Если СтрокаДерева <> Неопределено Тогда
			Если СтрокаДерева.Признак = "Группа" Тогда
				СтрокаДерева.Значение = Истина;
			ИначеЕсли СтрокаДерева.Признак = "Выбор" Тогда
				ТекИндекс = МассивРеквизитов.Найти(Элемент);
				СтрокаДерева.Значение = МассивРеквизитов[ТекИндекс+1];
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Возвращает таблицу значений с данными дерева значений
//
// Параметры:
//  ДеревоДанных - ДеревоЗначений - дерево с данными
//  НазваниеТаблицы - Строка - название таблицы в дереве, если необходимо получить данные табличной части.
//
// Возвращаемое значение:
//  ТаблицаЗначений - содержит данные дерева.
//
Функция ДанныеДерева(ДеревоДанных, НазваниеТаблицы = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(НазваниеТаблицы) Тогда
		Возврат ДанныеТаблицыДерева(ДеревоДанных, НазваниеТаблицы);
	Иначе
		Возврат ДанныеШапкиДерева(ДеревоДанных);
	КонецЕсли;
	
КонецФункции

// Возвращает строку дерева значений для заполнения в прикладном решении
//
// Параметры:
//  ДеревоДанных - ДеревоЗначений - дерево с данными
//  НазваниеПоля - Строка - название поля в дереве, содержащее полный путь к реквизиту
//  НайтиРекурсивно - Булево, Истина - если требуется рекурсивный поиск.
//
// Возвращаемое значение:
//  Строка таблицы значений - содержит строку дерева.
//
Функция СтрокаДерева(ДеревоДанных, НазваниеПоля, НайтиРекурсивно = Ложь) Экспорт
	
	СтрокаВозврата = ДеревоДанных.Строки.Найти(НазваниеПоля, "ПолныйПуть", НайтиРекурсивно);
	Если СтрокаВозврата.Признак = "Группа" Тогда
		СтрокаВозврата.Значение = Истина;
	КонецЕсли;
	Возврат СтрокаВозврата;

КонецФункции

// Копирует строки дерева значений
//
// Параметры:
//  СтрокаПолучатель - СтрокаДереваЗначений - строка дерева значений, в которую будут скопированы строки
//  СтрокаИсточник - СтрокаДереваЗначений - строка дерева значений, из которой будут скопированы строки.
Процедура СкопироватьСтрокиДереваРекурсивно(СтрокаПолучатель, СтрокаИсточник) Экспорт
	
	Для Каждого Реквизит Из СтрокаИсточник.Строки Цикл
		НовСтрока = СтрокаПолучатель.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтрока, Реквизит);
		Если Реквизит.Строки.Количество() > 0 Тогда
			СкопироватьСтрокиДереваРекурсивно(НовСтрока, Реквизит);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

// В процедуре происходит добавление данных из СтруктурыДанных в ДеревоЗначений.
//
// Параметры:
//  СтрокаДерева - ДеревоЗначений, СтрокаДереваЗначений - содержит данные.
//  СтруктураДопДанных - Структура - данные, которые необходимо поместить в дерево.
//  ЮридическиЗначимый - Булево - если Истина - то текущие данные необходимо по возможности поместить в основной ЭД.
//
Процедура ДобавитьДопДанныеВДерево(СтрокаДерева, СтруктураДопДанных, ЮридическиЗначимый = Ложь) Экспорт
	
	Если СтруктураДопДанных.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если СтрокаДерева.Строки.Родитель = Неопределено Тогда
		СтрокаДереваЗначений = СтрокаДерева(СтрокаДерева, "ДопДанные");
		Если ЮридическиЗначимый Тогда
			СтрокаДопДанные = СтрокаДереваЗначений.Строки.Найти("ДопДанные.Подписанные", "ПолныйПуть");
		Иначе
			СтрокаДопДанные = СтрокаДереваЗначений.Строки.Найти("ДопДанные.НеПодписанные", "ПолныйПуть");
		КонецЕсли;
	ИначеЕсли НазваниеКолонки(СтрокаДерева.ПолныйПуть) = "ДопДанныеПодписанные"
			ИЛИ НазваниеКолонки(СтрокаДерева.ПолныйПуть) = "ДопДанныеНеПодписанные" Тогда
		СтрокаДопДанные = СтрокаДерева;
	Иначе
		СтрокаДерева.Значение = Истина;
		СтрокаДопДанные = СтрокаДерева.Строки[?(ЮридическиЗначимый, 0 ,1)];
	КонецЕсли;
	СтрокаДопДанные.Значение = Истина;
	
	Для Каждого Элемент Из СтруктураДопДанных Цикл
		НовСтрока = СтрокаДопДанные.Строки.Найти(СтрокаДопДанные.ПолныйПуть + "." + Элемент.Ключ, "ПолныйПуть");
		Если НовСтрока = Неопределено Тогда
			НовСтрока = СтрокаДопДанные.Строки.Добавить();
			НовСтрока.ПолныйПуть = СтрокаДопДанные.ПолныйПуть + "." + Элемент.Ключ;
			НомерУровня = СтрЧислоВхождений(НовСтрока.ПолныйПуть, ".") + 1;
			НовСтрока["Уровень" + НомерУровня] = НазваниеКолонки(НовСтрока.ПолныйПуть);
		КонецЕсли;
		НовСтрока.Значение = Элемент.Значение;
	КонецЦикла;
	
КонецПроцедуры

// Возвращает название реквизита из полного пути
//
// Параметры:
//  ПолныйПуть - Строка - Полный путь до реквизита в дереве.
//
// Возвращаемое значение:
//  Строка - Название реквизита
//
Функция НазваниеКолонки(ПолныйПуть) Экспорт
	
	МассивСтрок = ОбщегоНазначенияКлиентСервер.РазложитьСтрокуПоТочкамИСлэшам(ПолныйПуть);
	Возврат МассивСтрок[МассивСтрок.Количество()-1];
	
КонецФункции

// Проверяет существование реквизита в дереве, по указанному пути.
//
// Параметры:
//  ДеревоДанных - ДеревоЗначений - область данных поиска.
//  ПолныйПуть - Строка - значение поиска.
// 
// Возвращаемое значение:
//  Булево - Истина, если реквизит существует.
//
Функция СуществуетРеквизитВДереве(ДеревоДанных, ПолныйПуть) Экспорт
	
	Существует = Ложь;
	НайденнаяСтрока = ДеревоДанных.Строки.Найти(ПолныйПуть, "ПолныйПуть", Истина);
	Если НайденнаяСтрока <> Неопределено Тогда
		Существует = Истина;
	КонецЕсли;
	
	Возврат Существует;
	
КонецФункции

#КонецОбласти

#Область ИнтеграцияСБиблиотекойТехнологияСервиса

// См. процедуру ТарификацияПереопределяемый.ПриФормированииСпискаУслуг
//
Процедура ПриФормированииСпискаУслуг(ПоставщикиУслуг) Экспорт
	
	// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами") Тогда
		МодульОбменСКонтрагентами = ОбщегоНазначения.ОбщийМодуль("ОбменСКонтрагентами");
		МодульОбменСКонтрагентами.ПриФормированииСпискаУслуг(ПоставщикиУслуг);
	КонецЕсли;
	// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	
	// ЭлектронноеВзаимодействие.БизнесСеть
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.БизнесСеть") Тогда
		МодульОбменБизнесСеть = ОбщегоНазначения.ОбщийМодуль("БизнесСеть");
		МодульОбменБизнесСеть.ПриФормированииСпискаУслуг(ПоставщикиУслуг);
	КонецЕсли;
	// Конец ЭлектронноеВзаимодействие.БизнесСеть
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеШапкиДерева(ДеревоДанных)
	
	ТаблицаВозврата = Новый ТаблицаЗначений;
	Для Каждого Колонка Из ДеревоДанных.Колонки Цикл
		ТаблицаВозврата.Колонки.Добавить(Колонка.Имя);
	КонецЦикла;
	
	ЗаполнитьТаблицуРекурсивно(ТаблицаВозврата, ДеревоДанных.Строки);
	
	Возврат ТаблицаВозврата;
	
КонецФункции

Функция ДанныеТаблицыДерева(ДеревоДанных, НазваниеТаблицы)
	
	ТаблицаВозврата = Новый ТаблицаЗначений;
	СтрокаТаблицы = ДеревоДанных.Строки.Найти(НазваниеТаблицы, "ПолныйПуть");
	НомерСтроки = СтрокаТаблицы.Строки[0];
	Для Каждого Строка Из НомерСтроки.Строки Цикл
		ТаблицаВозврата.Колонки.Добавить(НазваниеКолонки(Строка.ПолныйПуть));
	КонецЦикла;
	
	Для Каждого Строка Из СтрокаТаблицы.Строки Цикл
		НовСтрока = ТаблицаВозврата.Добавить();
		Для Каждого СтрокаРеквизита Из Строка.Строки Цикл
			НовСтрока[НазваниеКолонки(СтрокаРеквизита.ПолныйПуть)] = СтрокаРеквизита.Значение;
		КонецЦикла;
	КонецЦикла;
		
	Возврат ТаблицаВозврата;
	
КонецФункции

Процедура ЗаполнитьТаблицуРекурсивно(ТаблицаЗначений, СтрокиДерева, НазваниеТаблицы = Неопределено)
	
	Для Каждого Строка Из СтрокиДерева Цикл
		Если НЕ Строка.Признак = "Таблица" Тогда
			НовСтрока = ТаблицаЗначений.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтрока, Строка);
			Если Строка.Строки.Количество()>0 Тогда
				ЗаполнитьТаблицуРекурсивно(ТаблицаЗначений, Строка.Строки);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура СкопироватьСтрокиДереваДляТаблицыРекурсивно(СтрокаПолучатель, СтрокаИсточник)
	
	Для Каждого Реквизит Из СтрокаИсточник.Строки Цикл
		Если НазваниеКолонки(Реквизит.ПолныйПуть) = "НомерСтроки" И ТипЗнч(Реквизит.Значение) = Тип("Число")
				И Реквизит.Значение > 1 Тогда
			Прервать;
		КонецЕсли;
		НовСтрока = СтрокаПолучатель.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтрока, Реквизит);
		НовСтрока.Значение = "";
		Если Реквизит.Строки.Количество() > 0 Тогда
			СкопироватьСтрокиДереваДляТаблицыРекурсивно(НовСтрока, Реквизит);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

Функция СтруктураКолонокТаблицыДерева(Дерево, НазваниеТаблицы)
	
	СтруктураВозврата = Новый Структура;
	
	СтрокаДерева = Дерево.Строки.Найти(НазваниеТаблицы + ".НомерСтроки", "ПолныйПуть", Истина);
	Для Каждого Подстрока Из СтрокаДерева.Строки Цикл
		НазваниеКолонки = НазваниеКолонки(Подстрока.ПолныйПуть);
		Если НазваниеКолонки = "ДопДанные" Тогда
			СтруктураВозврата.Вставить("ДопДанныеПодписанные");
			СтруктураВозврата.Вставить("ДопДанныеНеПодписанные");
		Иначе
			СтруктураВозврата.Вставить(НазваниеКолонки);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтруктураВозврата;
	
КонецФункции

Процедура РекурсивноЗаполнитьСтрокиДерева(ДеревоЗначений, Знач НомерУровня, КолУровней, Знач ПолныйПутьВДереве, ТЗ, НомерСтрокиТЗ)
	
	ЛокальныйПуть = ПолныйПутьВДереве;
	СтрокаТекУровня = Неопределено;
	Пока НомерСтрокиТЗ < ТЗ.Количество() Цикл
		СтрокаТЗ = ТЗ[НомерСтрокиТЗ];
		Для Сч = НомерУровня По КолУровней Цикл
			ИдТекУровня = "Уровень" + Сч;
			Если ТЗ.Колонки.Найти(ИдТекУровня) <> Неопределено И ЗначениеЗаполнено(СтрокаТЗ[ИдТекУровня]) Тогда
				Если НомерУровня < Сч Тогда
					РекурсивноЗаполнитьСтрокиДерева(СтрокаТекУровня, Сч, КолУровней, ЛокальныйПуть, ТЗ, НомерСтрокиТЗ);
				ИначеЕсли НомерУровня = Сч Тогда
					СтрокаТекУровня = ДеревоЗначений.Строки.Добавить();
					ЗаполнитьЗначенияСвойств(СтрокаТекУровня, СтрокаТЗ);
					ЛокальныйПуть = ?(ПолныйПутьВДереве = "", "", ПолныйПутьВДереве + ".") + СтрокаТекУровня["Уровень" + Сч];
					СтрокаТекУровня.ПолныйПуть = ЛокальныйПуть;
				КонецЕсли;
				НомерСтрокиТЗ = НомерСтрокиТЗ + 1;
				Прервать;
			КонецЕсли;
			Если Сч >= КолУровней Тогда
				НомерСтрокиТЗ = НомерСтрокиТЗ - 1;
				Возврат;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры



#КонецОбласти
