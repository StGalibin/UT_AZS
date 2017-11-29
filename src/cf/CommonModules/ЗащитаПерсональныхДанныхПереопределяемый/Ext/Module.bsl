﻿#Область ПрограммныйИнтерфейс

// Обеспечивает сбор сведений о хранении данных, относящихся к персональным.
//
// Параметры:
//		ТаблицаСведений - ТаблицаЗначений - таблица с полями:
//			* Объект 			- Строка - полное имя объекта метаданных;
//			* ПоляРегистрации	- Строка - имена полей регистрации, отдельные поля регистрации отделяются запятой,
//										альтернативные - символом "|";
//			* ПоляДоступа		- Строка - имена полей доступа через запятую.
//			* ОбластьДанных		- Строка - идентификатор области данных, необязательно для заполнения.
//
Процедура ЗаполнитьСведенияОПерсональныхДанных(ТаблицаСведений) Экспорт
	
	
	// СтандартныеПодсистемы.ФизическиеЛица
	Если ТаблицаСведений.Найти("Справочник.ФизическиеЛица", "Объект") = Неопределено Тогда
		НовыеСведения = ТаблицаСведений.Добавить();
		НовыеСведения.Объект			= "Справочник.ФизическиеЛица";
		НовыеСведения.ПоляРегистрации	= "Ссылка";
		НовыеСведения.ПоляДоступа		= "ДатаРождения,Пол,ИНН";
		НовыеСведения.ОбластьДанных		= "ЛичныеДанные";
		
		НовыеСведения = ТаблицаСведений.Добавить();
		НовыеСведения.Объект			= "Справочник.ФизическиеЛица";
		НовыеСведения.ПоляРегистрации	= "Ссылка";
		НовыеСведения.ПоляДоступа		= "КонтактнаяИнформация.ЗначенияПолей,КонтактнаяИнформация.Представление,КонтактнаяИнформация.Регион,КонтактнаяИнформация.Город,КонтактнаяИнформация.АдресЭП,КонтактнаяИнформация.НомерТелефона,КонтактнаяИнформация.НомерТелефонаБезКодов";
		НовыеСведения.ОбластьДанных		= "КонтактнаяИнформация";
	КонецЕсли;
	
	Если ТаблицаСведений.Найти("РегистрСведений.ДокументыФизическихЛиц", "Объект") = Неопределено Тогда
		НовыеСведения = ТаблицаСведений.Добавить();
		НовыеСведения.Объект			= "РегистрСведений.ДокументыФизическихЛиц";
		НовыеСведения.ПоляРегистрации	= "Физлицо";
		НовыеСведения.ПоляДоступа		= "ВидДокумента,Серия,Номер,ДатаВыдачи,СрокДействия,КемВыдан,КодПодразделения,Представление";
		НовыеСведения.ОбластьДанных		= "ПаспортныеДанные";
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ФизическиеЛица
	
КонецПроцедуры

// Обеспечивает составление коллекции областей персональных данных.
//
// Параметры:
//		ОбластиПерсональныхДанных - ТаблицаЗначений - таблица с полями:
//			* Имя			- Строка - идентификатор области данных.
//			* Представление	- Строка - пользовательское представление области данных.
//			* Родитель		- Строка - идентификатор родительской области данных.
//
Процедура ЗаполнитьОбластиПерсональныхДанных(ОбластиПерсональныхДанных) Экспорт
	
	
	// СтандартныеПодсистемы.ФизическиеЛица
	Если ОбластиПерсональныхДанных.Найти("ЛичныеДанные", "Имя") = Неопределено Тогда
		НоваяОбласть = ОбластиПерсональныхДанных.Добавить();
		НоваяОбласть.Имя = "ЛичныеДанные";
		НоваяОбласть.Представление = НСтр("ru = 'Личные данные'");
	КонецЕсли;
	
	Если ОбластиПерсональныхДанных.Найти("ПаспортныеДанные", "Имя") = Неопределено Тогда
		НоваяОбласть = ОбластиПерсональныхДанных.Добавить();
		НоваяОбласть.Имя = "ПаспортныеДанные";
		НоваяОбласть.Представление = НСтр("ru = 'Паспортные данные'");
		НоваяОбласть.Родитель = "ЛичныеДанные";
	КонецЕсли;
	
	Если ОбластиПерсональныхДанных.Найти("КонтактнаяИнформация", "Имя") = Неопределено Тогда
		НоваяОбласть = ОбластиПерсональныхДанных.Добавить();
		НоваяОбласть.Имя = "КонтактнаяИнформация";
		НоваяОбласть.Представление = НСтр("ru = 'Адреса и телефоны'");
		НоваяОбласть.Родитель = "ЛичныеДанные";
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ФизическиеЛица
	
КонецПроцедуры

// Вызывается при заполнении формы "Согласие на обработку персональных данных" данными, 
// переданных в качестве параметров, субъектов.
//
// Параметры:
//		СубъектыПерсональныхДанных 	- ДанныеФормыКоллекция - содержит сведения о субъектах.
//		ДатаАктуальности			- Дата - дата, на которую нужно заполнить сведения.
//
Процедура ДополнитьДанныеСубъектовПерсональныхДанных(СубъектыПерсональныхДанных, ДатаАктуальности) Экспорт
	
	Для Каждого СтрокаСубъект Из СубъектыПерсональныхДанных Цикл
		Если ТипЗнч(СтрокаСубъект.Субъект) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
			СтрокаСубъект.ФИО 			   = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаСубъект.Субъект, "Наименование");
			СтрокаСубъект.ПаспортныеДанные = РегистрыСведений.ДокументыФизическихЛиц.ДокументУдостоверяющийЛичностьФизлица(СтрокаСубъект.Субъект, ДатаАктуальности);
			СтрокаСубъект.Адрес 		   = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(СтрокаСубъект.Субъект, Справочники.ВидыКонтактнойИнформации.АдресПоПропискеФизическиеЛица);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Вызывается при заполнении формы "Согласие на обработку персональных данных" данными организации.
//
// Параметры:
//		Организация					- ОпределяемыйТип.Организация - оператор персональных данных.
//		ДанныеОрганизации			- Структура - данные об организации (адрес, ФИО ответственного и т.д.).
//		ДатаАктуальности			- Дата      - дата, на которую нужно заполнить сведения.
//
Процедура ДополнитьДанныеОрганизацииОператораПерсональныхДанных(Организация, ДанныеОрганизации, ДатаАктуальности) Экспорт
	
	ДанныеОрганизации.Вставить(
		"АдресОрганизации",
		УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(
			Организация,
			Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации, ДатаАктуальности));
	ДанныеОрганизации.Вставить(
		"ОтветственныйЗаОбработкуПерсональныхДанных",
		ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(
			ОтветственныеЛицаСервер.ПолучитьДанныеОтветственногоЛица(
				Организация,
				ДатаАктуальности,
				Перечисления.ОтветственныеЛицаОрганизаций.РуководительКадровойСлужбы
			).ФизическоеЛицо,
			ДатаАктуальности));
	
КонецПроцедуры

#КонецОбласти
