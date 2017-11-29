﻿
#Область ПрограммныйИнтерфейс

#Область ОбщиеПроцедурыИФункцииФормСпискаИВыбораСправочникаПартнеры

// При перетаскивании в форме списка обновляет значение реквизита, на которое было выполнено перетаскивание для массива перетаскиваемых партнеров.
//
// Параметры:
//  Значение              - Произовольный - значение, на которое было выполнено перетаскивание.
//  МассивПартнеров       - Массив - массив перетаскиваемых партнеров.
//  КоличествоЗаписанных  - Число - количество записанных партнеров.
//
Процедура ОбновитьЗначениеРеквизитаУПеретаскиваемыхПартнеров(Значение, МассивПартнеров, КоличествоЗаписанных) Экспорт

	КоличествоЗаписанных = 0;
	МассивГруппДоступныхДляИзменения =
		УправлениеДоступом.ГруппыЗначенийДоступаРазрешающиеИзменениеЗначенийДоступа(Тип("СправочникСсылка.Партнеры"), Истина);
	
	ИмяРеквизита = "";
	Если ТипЗнч(Значение) = Тип("СправочникСсылка.БизнесРегионы") Тогда
		ИмяРеквизита = "БизнесРегион";
	ИначеЕсли ТипЗнч(Значение) = Тип("СправочникСсылка.ГруппыДоступаПартнеров") Тогда
		ИмяРеквизита = "ГруппаДоступа";
		Если МассивГруппДоступныхДляИзменения.Найти(Значение) = Неопределено Тогда
			Возврат;
		КонецЕсли;
	ИначеЕсли ТипЗнч(Значение) = Тип("СправочникСсылка.Пользователи") Тогда
		ИмяРеквизита = "ОсновнойМенеджер";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	Партнеры.Ссылка
	|ИЗ
	|	Справочник.Партнеры КАК Партнеры
	|ГДЕ
	|	Партнеры.Ссылка В(&МассивПартнеров)
	|	И Партнеры.ГруппаДоступа В (&МассивГруппДоступныхДляИзменения)
	|	И Партнеры.%ИмяРеквизита% <> &Значение";
	
	Запрос.УстановитьПараметр("МассивПартнеров",МассивПартнеров);
	Запрос.УстановитьПараметр("Значение",Значение);
	Запрос.УстановитьПараметр("МассивГруппДоступныхДляИзменения", МассивГруппДоступныхДляИзменения);
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "%ИмяРеквизита%", ИмяРеквизита);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
	
		ПартнерОбъект =  Выборка.Ссылка.ПолучитьОбъект();
		ПартнерОбъект[ИмяРеквизита] = Значение;
		ПартнерОбъект.Записать();
		КоличествоЗаписанных = КоличествоЗаписанных + 1;
	
	КонецЦикла;

КонецПроцедуры

// Получает основного менеджера бизнес-региона.
//
// Параметры:
//  БизнесРегион  - СправочникСсылка.БизнесРегионы - бизнес-регион, для которого получается основной менеджер.
//
// Возвращаемое значение:
//   СправочникСсылка.Пользователи   - основной менеджер бизнес-региона.
//
Функция ОсновнойМенеджерБизнесРегиона(БизнесРегион) Экспорт

	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(БизнесРегион,"ОсновнойМенеджер");

КонецФункции

// Получает партнера - объекта авторизации внешнего пользователя
//
// Возвращаемое значение:
//  СправочникСсылка.Партнеры - партнер,если объект авторизации партнер, неопределено в обратном случае
//
Функция ПолучитьАвторизовавшегосяПартнера() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВнешнийПользователь = ВнешниеПользователи.ТекущийВнешнийПользователь();
	Если НЕ ЗначениеЗаполнено(ВнешнийПользователь) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(ВнешнийПользователь.ОбъектАвторизации) = Тип("СправочникСсылка.Партнеры") Тогда
		Возврат ВнешнийПользователь.ОбъектАвторизации;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

// Формирует представление справочника Партнеры в зависимости от настроек раздельного или совместного использования партнеров и контрагентов.
//
// Возвращаемое значение:
//   Строка   - сформированное представление справочника Партнеры.
//
Функция ПредставлениеСправочникаПартнеры() Экспорт
	
	Возврат ?(ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов"), НСтр("ru = 'Контрагенты'"), НСтр("ru = 'Партнеры'"));
	
КонецФункции

// Получает структуру данных о авторизовавшемся внешнем пользователе
//
// Возвращаемое значение:
//  Структура - содержит информацию о авторизовавшемся внешнем пользвателе
//
Функция ДанныеАвторизовавшегосяВнешнегоПользователя() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВнешнийПользователь = ВнешниеПользователи.ТекущийВнешнийПользователь();
	Если НЕ ЗначениеЗаполнено(ВнешнийПользователь) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	АвторизованПартнер = Истина;
	Партнер            = Справочники.Партнеры.ПустаяСсылка();
	КонтактноеЛицо     = Справочники.КонтактныеЛицаПартнеров.ПустаяСсылка();
	
	ОбъектАвторизации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВнешнийПользователь, "ОбъектАвторизации");
	
	Если ТипЗнч(ОбъектАвторизации) = Тип("СправочникСсылка.Партнеры") Тогда
		Партнер        = ОбъектАвторизации;
	ИначеЕсли ТипЗнч(ОбъектАвторизации) = Тип("СправочникСсылка.КонтактныеЛицаПартнеров") Тогда
		АвторизованПартнер = Ложь;
		КонтактноеЛицо = ОбъектАвторизации;
		Партнер        = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОбъектАвторизации, "Владелец");
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	СтруктураКВозврату = Новый Структура;
	СтруктураКВозврату.Вставить("АвторизованПартнер", АвторизованПартнер);
	СтруктураКВозврату.Вставить("Партнер", Партнер);
	СтруктураКВозврату.Вставить("КонтактноеЛицо", КонтактноеЛицо);
	
	Возврат СтруктураКВозврату;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Устанавливает подчиненному контрагенту его головного контрагенту
//
// Параметры
//  Контрагент  - СправочникСсылка.Контрагенты - контрагент, которому задается головной
//  ГоловнойКонтрагент  - СправочникСсылка.Контрагенты - устанавливаемое значение головного контрагента
//  ОписаниеОщибки  - Строка - параметр, в который записываются возникшие ошибки
//
Процедура ИзменитьГоловногоКонтрагента(Контрагент, ГоловнойКонтрагент, ОписаниеОшибки) Экспорт
	
	ИНН = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ГоловнойКонтрагент, "ИНН");
	
	Если ЗначениеЗаполнено(ИНН) Тогда
		
		КПП = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент, "КПП");
		
		ВыборкаКонтрагент = ПартнерыИКонтрагенты.ИННКППУжеИспользуетсяВИнформационнойБазе(ИНН, КПП, Контрагент);
		Если ВыборкаКонтрагент <> Неопределено Тогда
			ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Не удалось изменить головного контрагента для %1.
				|Данные ИНН и КПП уже указаны для контрагента с кодом %2, ответственный - %3.
				|Попробуйте указать правильный КПП, и лишь затем выбрать головного контрагента.'"),
				Контрагент,
				ВыборкаКонтрагент.Код,
				ВыборкаКонтрагент.ОсновнойМенеджер);
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	КонтрагентОбъект = Контрагент.ПолучитьОбъект();
	
	Попытка
		КонтрагентОбъект.Заблокировать();
	Исключение
		ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось изменить головного контрагента для %1.
				|Возможно, контрагент в настоящий момент редактируется.'"),
			Контрагент);
		Возврат;
	КонецПопытки;
	
	КонтрагентОбъект.ГоловнойКонтрагент = ГоловнойКонтрагент;
	КонтрагентОбъект.ИНН = ИНН;
	КонтрагентОбъект.Записать();
	
	КонтрагентОбъект.Разблокировать();
	
КонецПроцедуры

Функция ЗначенияПолейКонтактнойИнформации(Знач Представление, Знач ВидКонтактнойИнформации, Знач Комментарий = Неопределено) Экспорт
	
	// Создаем новый экземпляр по представлению
	Результат = УправлениеКонтактнойИнформациейСлужебныйВызовСервера.КонтактнаяИнформацияXMLПоПредставлению(Представление, ВидКонтактнойИнформации);
	
	// Добавляем в него комментарий, если есть
	Если Комментарий <> Неопределено Тогда
		Комментарий = УправлениеКонтактнойИнформацией.КомментарийКонтактнойИнформации(Результат);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции 

// Получает данные контрагента по ИНН в зависимости от типа контрагента.
//
// Параметры:
//  ЭтоЮридическоеЛицо  - Булево - Истина, если юридическое лицо, Ложь если индивидуальный предприниматель.
//  ИНН                 - Строка - ИНН, по которому будут получатся данные.
//
// Возвращаемое значение:
//   Структура   - полученные данные. Описание струтур см. в 
//                  РаботаСКонтрагентами.НовыеРеквизитыЮридическогоЛица() и 
//                  РаботаСКонтрагентами.НовыеРеквизитыПредпринимателя()
//
Функция ДанныеКонтрагентаПоИНН(ЭтоЮридическоеЛицо, ИНН, ИдентификаторЗадания) Экспорт
	
	Если ТипЗнч(ИдентификаторЗадания) = Тип("УникальныйИдентификатор") Тогда
		Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
		
		Если Задание <> Неопределено
			И Задание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
			Задание.Отменить();
		КонецЕсли;
	КонецЕсли;
	
	Если ЭтоЮридическоеЛицо Тогда
		Возврат РаботаСКонтрагентами.РеквизитыЮридическогоЛицаПоИНН(ИНН);
	Иначе
		Возврат РаботаСКонтрагентами.РеквизитыПредпринимателяПоИНН(ИНН);
	КонецЕсли;
	
КонецФункции

// Запускает фоновое задание по получению данных контрагента с сервиса, согласно указанному ИНН.
//
// Параметры:
//  ИНН  - Строка - ИНН контрагента, согласно которому будет выполнен поиск данных
//  ЮрФизЛицо  - Перечисления.ЮрФизЛицо - в зависимости от значения поиск будет выполнен либо в ЕГРЮЛ ЛИБО ЕГРИП.
//  УникальныйИдентификатор  - УникальныйИдентификатор - уникальный идентификатор запускаемого регламентного задания.
//
// Возвращаемое значение:
//   РезультатЗапуска   - структура, содержит следующие параметры:
//        ЗаданиеЗапущено      - Булево - Истина, если задание удалось выполнить сразу.
//        РеквизитыКонтрагента - Структура - данные контрагента, если они были получены сразу.
//        ИдентификаторЗадания - Строка - идентификатор запущенного фонового задания.
//        АдресХранилища       - Строка - адрес хранилища, в которое будет помещен результат выполнения.
Функция ФоновоеЗаданиеДанныеПартнераПоИННЗапустить(ИНН, ЮрФизЛицо, УникальныйИдентификатор, ИдентификаторЗадания) Экспорт
	
	РезультатЗапуска = Новый Структура("ЗаданиеЗапущено, РеквизитыКонтрагента", Ложь, Неопределено);
	РезультатЗапуска.Вставить("ИдентификаторЗадания","");
	РезультатЗапуска.Вставить("АдресХранилища","");
	
	Если ТипЗнч(ИдентификаторЗадания) = Тип("УникальныйИдентификатор") Тогда
		Задание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
		
		Если Задание <> Неопределено
			И Задание.Состояние = СостояниеФоновогоЗадания.Активно Тогда
			Задание.Отменить();
		КонецЕсли;
	КонецЕсли;
	
	ИнформацияОбОшибке = Неопределено;
	ПараметрыФормирования = Новый Структура;
	ПараметрыФормирования.Вставить("ИНН", ИНН);
	ПараметрыФормирования.Вставить("ЭтоЮридическоеЛицо", ОбщегоНазначенияУТКлиентСервер.ЭтоЮрЛицо(ЮрФизЛицо));
	
	Попытка
		РезультатФоновогоЗадания = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"ПартнерыИКонтрагенты.ДанныеКонтрагентаПоИННФоновоеЗадание",
			ПараметрыФормирования,
			НСтр("ru = 'Работа с контрагентами: получение реквизитов по ИНН.'"));
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Возврат РезультатЗапуска;
	КонецПопытки;
	
	РезультатЗапуска.ИдентификаторЗадания  = РезультатФоновогоЗадания.ИдентификаторЗадания;
	РезультатЗапуска.АдресХранилища        = РезультатФоновогоЗадания.АдресХранилища;
	
	Если РезультатФоновогоЗадания.ЗаданиеВыполнено Тогда
		РезультатЗапуска.РеквизитыКонтрагента = ПолучитьИзВременногоХранилища(РезультатФоновогоЗадания.АдресХранилища);
	Иначе
		РезультатЗапуска.ЗаданиеЗапущено      = Истина;
	КонецЕсли;
	
	Возврат РезультатЗапуска;
	
КонецФункции

// Проверяет, выполнено ли ранее запущенное фоновое задание по получению данных контрагента по ИНН.
//
// Параметры:
//  ЗаданиеИдентификатор  - Строка - идентификатор фонового задания.
//  АдресХранилища        - Строка - адрес хранилища, в которое будет помещен результат выполнения.
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   РезультатВыполнения   - структура, содержит следующие параметры:
//        ЗаданиеВыполнено      - Булево - Истина, если задание выполнено.
//        РеквизитыКонтрагента  - Структура - полученные данные контрагента.
//
Функция ФоновоеЗаданиеВыполнено(ЗаданиеИдентификатор, АдресХранилища) Экспорт
	
	РезультатВыполнения = Новый Структура("ЗаданиеВыполнено, РеквизитыКонтрагента", Ложь, Неопределено);
	
	Попытка
		РезультатВыполнения.ЗаданиеВыполнено = ДлительныеОперации.ЗаданиеВыполнено(ЗаданиеИдентификатор);
	Исключение
		РезультатВыполнения.ЗаданиеВыполнено = Ложь;
	КонецПопытки;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		РезультатВыполнения.РеквизитыКонтрагента = ПолучитьИзВременногоХранилища(АдресХранилища);
	КонецЕсли;
	
	Возврат РезультатВыполнения;
	
КонецФункции

Функция ИмяФормыСозданияКонтрагента() Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		Возврат "Справочник.Партнеры.Форма.ПомощникНового";
	Иначе
		Возврат "Справочник.Контрагенты.Форма.ФормаЭлемента";
	КонецЕсли;
	
КонецФункции

Функция МассивУстановленыхПараметровОтбораПоТипуПартнера(Параметры) Экспорт
	
	МассивУстановленныхОтборов = Новый Массив;
	Если Параметры.Отбор.Свойство("Клиент") Тогда
		МассивУстановленныхОтборов.Добавить("Клиент");
	КонецЕсли;
	Если Параметры.Отбор.Свойство("Поставщик") Тогда
		МассивУстановленныхОтборов.Добавить("Поставщик");
	КонецЕсли;
	Если Параметры.Отбор.Свойство("Конкурент") Тогда
		МассивУстановленныхОтборов.Добавить("Конкурент");
	КонецЕсли;
	Если Параметры.Отбор.Свойство("ПрочиеОтношения") Тогда
		МассивУстановленныхОтборов.Добавить("ПрочиеОтношения");
	КонецЕсли;
	Если Параметры.Отбор.Свойство("ОбслуживаетсяТорговымиПредставителями") Тогда
		МассивУстановленныхОтборов.Добавить("ОбслуживаетсяТорговымиПредставителями");
	КонецЕсли;
	
	Возврат МассивУстановленныхОтборов;
	
КонецФункции

Функция СтрокаОтбораЗапросаПоТипуПартнера(Параметры, МассивУстановленныхОтборов) Экспорт
	
	УстанавливатьОтборПоТипуПартнераКакИЛИ = Параметры.Свойство("УстанавливатьОтборПоТипуПартнераКакИЛИ") И Параметры.УстанавливатьОтборПоТипуПартнераКакИЛИ;
		
	СтрокаОтбора = "";
	СтрокаУсловия = ?(УстанавливатьОтборПоТипуПартнераКакИЛИ," ИЛИ "," И ");
	
	Для каждого ЭлементМассива Из МассивУстановленныхОтборов Цикл
	
		СтрокаОтбора = СтрокаОтбора + СтрокаУсловия + "Партнеры." + ЭлементМассива; 
	
	КонецЦикла;
	
	СтрокаОтбора = Прав(СтрокаОтбора,СтрДлина(СтрокаОтбора) - ?(УстанавливатьОтборПоТипуПартнераКакИЛИ,4,2));
	Возврат ?(ПустаяСтрока(СтрокаОтбора),""," И (" + СтрокаОтбора + ")");
	
КонецФункции

Процедура ЗаполнитьКонтрагентаПартнераПоУмолчанию(Знач Партнер, Контрагент, ПерезаполнятьКонтрагента) Экспорт
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Партнер, Контрагент, ПерезаполнятьКонтрагента);
	
КонецПроцедуры

Процедура ЗаполнитьДанныеКонтрагентаПартнера(Приемник, Партнер, СИсторическимиДанными = Истина) Экспорт
	
	ПартнерыИКонтрагенты.ЗаполнитьДанныеКонтрагентаПартнера(Приемник, Партнер, СИсторическимиДанными);
	
КонецПроцедуры

#КонецОбласти
