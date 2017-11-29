﻿///////////////////////////////////////////////////////////////////////////////
// Модуль "НаправленияДеятельностиСервер", содержит процедуры и функции необходимые для
// работы серверной части форм накладных и заказов.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ОбщиеОбработчикиСобытийФорм

// Используется в формах документов, в одноименных процедурах "ПриЧтенииСозданииНаСервере".
// Инициализирует реквизиты формы, используемые при интерактивной работе пользователя. Заполняет назначение, исходя из направления деятельности.
//
// Параметры:
//  Форма - УправляемаяФорма - форма в которой необходимо инициализировать реквизиты связанные с использованием направлений деятельности.
//
Процедура ПриЧтенииСозданииНаСервере(Форма) Экспорт
	
	ИспользоватьНаправленияДеятельности = ПолучитьФункциональнуюОпцию("ИспользоватьУчетЗатратПоНаправлениямДеятельности");
	ИспользоватьОбособленноеОбеспечениеЗаказов = ПолучитьФункциональнуюОпцию("ИспользоватьОбособленноеОбеспечениеЗаказов");
	ЭтоИсточникПотребности = Форма.МетаданныеФормы.ЭтоИсточникПотребности;
	ЕстьНазначениеВТЧ = Форма.МетаданныеФормы.ЕстьНазначениеВТЧ;
	
	Форма.НаправленияДеятельностиКэшированныеЗначения = НаправленияДеятельностиКэшированныеЗначения();
	Кэш = Форма.НаправленияДеятельностиКэшированныеЗначения;
	Кэш.ИспользоватьОбособленноеОбеспечениеЗаказов = ИспользоватьОбособленноеОбеспечениеЗаказов;
	Кэш.ИспользоватьНаправленияДеятельности        = ИспользоватьНаправленияДеятельности;
	
	Если ЭтоИсточникПотребности Тогда
		
		Если Не ЗначениеЗаполнено(Форма.Объект.Назначение) Тогда
			
			// Получение параметров формы.
			НаправлениеДеятельности = Форма.Объект.НаправлениеДеятельности;
			Ссылка = Форма.Объект.Ссылка;
		
			// Обработка.
			Назначение = Справочники.Назначения.НазначениеЗаказа(Ссылка, НаправлениеДеятельности);
			
			// Запись данных формы.
			Форма.Объект.Назначение = Назначение;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЕстьНазначениеВТЧ Тогда
		
		// Получение параметров формы.
		НаправлениеДеятельности = Форма.Объект.НаправлениеДеятельности;
		Назначение = ТолкающееНазначение(НаправлениеДеятельности);
		
		// Запись данных формы.
		Кэш.НазначениеПоУмолчанию = Назначение;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовНаФормах

// Используется в формах документов, в процедурах, приводящих к изменению направления деятельности.
// Инициализирует реквизиты формы, используемые при интерактивной работе пользователя. Заполняет назначение, исходя из направления деятельности.
// При необходимости актуализирует назначения в табличных частях документа, в соответствии с изменившимся направлением деятельности.
//
// Параметры:
//  Форма - УправляемаяФорма - форма в которой необходимо инициализировать реквизиты связанные с использованием направлений деятельности.
//
// Возвращаемое значение:
//  Массив - массив измененных строк табличной части документа.
//
Функция ПриИзмененииНаправленияДеятельностиСервер(Форма) Экспорт
	
	НайденныеСтроки = Новый Массив();
	
	Кэш = Форма.НаправленияДеятельностиКэшированныеЗначения;
	
	Если Не Кэш.ИспользоватьНаправленияДеятельности Или Не Кэш.ИспользоватьОбособленноеОбеспечениеЗаказов Тогда
		Возврат НайденныеСтроки;
	КонецЕсли;
	
	ЭтоИсточникПотребности = Форма.МетаданныеФормы.ЭтоИсточникПотребности;
	ЕстьНазначениеВТЧ = Форма.МетаданныеФормы.ЕстьНазначениеВТЧ;
	
	Если ЭтоИсточникПотребности Тогда
		
		// Получение параметров формы.
		НаправлениеДеятельности = Форма.Объект.НаправлениеДеятельности;
		Ссылка = Форма.Объект.Ссылка;
		
		// Обработка.
		Назначение = Справочники.Назначения.НазначениеЗаказа(Ссылка, НаправлениеДеятельности);
		
		// Запись данных формы.
		Форма.Объект.Назначение = Назначение;
		
	КонецЕсли;
	
	Если ЕстьНазначениеВТЧ Тогда
		
		// Получение данных формы.
		НаправлениеДеятельности = Форма.Объект.НаправлениеДеятельности;
		
		// Обработка.
		Назначение = ТолкающееНазначение(НаправлениеДеятельности);
		ЗаполнятьНазначение = ЗначениеЗаполнено(Назначение) Или ЗначениеЗаполнено(НаправлениеДеятельности) Или Форма.МетаданныеФормы.ВТЧНазначениеОтгрузки;
		Если ЗаполнятьНазначение Тогда
			
			// Получение объекто-зависимых данных формы.
			УсловияОтбора = Новый ТаблицаЗначений();
			УсловияОтбора.Колонки.Добавить("ТипНоменклатуры");
			УсловияОтбора.Колонки.Добавить("КодСтроки");
			
			НоваяСтрока = УсловияОтбора.Добавить();
			НоваяСтрока.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Товар;
			НоваяСтрока.КодСтроки = 0;
			НоваяСтрока = УсловияОтбора.Добавить();
			НоваяСтрока.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Работа;
			НоваяСтрока.КодСтроки = 0;
			
			НайденныеСтроки = НайтиСтрокиВКоллекциях(Форма, Форма.МетаданныеФормы, "ПОСТУПЛЕНИЕ", УсловияОтбора);
			ПроверитьЗаполнитьНазначенияСтрокахКоллекции(НайденныеСтроки, НаправлениеДеятельности);
			
		КонецЕсли;
	
		// Запись данных формы.
		Кэш.НазначениеПоУмолчанию = Назначение;
		
	КонецЕсли;
	
	Возврат НайденныеСтроки;
	
КонецФункции


// Используется в форме документа заказ переработчику при заполнении документа по спецификации.
// Инициализирует реквизиты формы, используемые при интерактивной работе пользователя. Заполняет назначение, исходя из направления деятельности.
//
// Параметры:
//  Форма - УправляемаяФорма - форма в которой необходимо инициализировать реквизиты связанные с использованием направлений деятельности.
//
Процедура ПриЗаполненииПоСпецификацииСервер(Форма) Экспорт
	
	Кэш = Форма.НаправленияДеятельностиКэшированныеЗначения;
	
	Если Не Кэш.ИспользоватьНаправленияДеятельности Или Не Кэш.ИспользоватьОбособленноеОбеспечениеЗаказов Тогда
		Возврат;
	КонецЕсли;
	
	// Получение данных формы.
	Назначение = Кэш.НазначениеПоУмолчанию;
	НаправлениеДеятельности = Форма.Объект.НаправлениеДеятельности;
	
	ЗаполнятьНазначение = ЗначениеЗаполнено(Назначение) Или ЗначениеЗаполнено(НаправлениеДеятельности);
	
	Если ЗаполнятьНазначение Тогда
		
		// Обработка.
		УсловияОтбора = Новый ТаблицаЗначений();
		УсловияОтбора.Колонки.Добавить("ТипНоменклатуры");
		
		НоваяСтрока = УсловияОтбора.Добавить();
		НоваяСтрока.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Товар;
		НоваяСтрока = УсловияОтбора.Добавить();
		НоваяСтрока.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Работа;
		
		НайденныеСтроки = НайтиСтрокиВКоллекциях(Форма, Форма.МетаданныеФормы, "ВОЗВРАТНЫЕОТХОДЫ", УсловияОтбора);
		ПроверитьЗаполнитьНазначенияСтрокахКоллекции(НайденныеСтроки, НаправлениеДеятельности);
		
	КонецЕсли;
	
КонецПроцедуры

// Используется в форме документа Сборка товаров для актуализации назначения при разборке под направление деятельности.
//
// Параметры:
//  НаправлениеДеятельности - СправочникСсылка.НаправленияДеятельности - направление деятельности.
//
// Возвращаемое значение:
//  СправочникСсылка.Назначения - назначение, связанное с направлением деятельности,
//                                если это направление деятельности с обособлением по направлению в целом.
//
Функция ТолкающееНазначение(НаправлениеДеятельности) Экспорт
	
	Назначение = Справочники.Назначения.ПустаяСсылка();
	Если ЗначениеЗаполнено(НаправлениеДеятельности) Тогда
		
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НаправлениеДеятельности, "ВариантОбособления, Назначение");
		Если Реквизиты.ВариантОбособления = Перечисления.ВариантыОбособленияПоНаправлениюДеятельности.ПоНаправлениюВЦелом Тогда
			
			Назначение = Реквизиты.Назначение;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Назначение;
	
КонецФункции

#КонецОбласти

// Заполняет направление из соглашения или договора
//
// Параметры:
//  НаправлениеДеятельности - СправочникСсылка.НаправленияДеятельности - направление деятельности, которое будет заполнено.
//  Соглашение - СправочникСсылка.СоглашенияСКлиентами, СправочникСсылка.СоглашенияСПоставщиками - Соглашение документа.
//  Договор - СправочникСсылка.ДоговорыКонтрагентов, СправочникСсылка.ДоговорыКредитовИДепозитов, СправочникСсылка.ДоговорыЛизинга, СправочникСсылка.ДоговорыМеждуОрганизациями - Договор документа.
//
Процедура ЗаполнитьНаправлениеПоУмолчанию(НаправлениеДеятельности, Знач Соглашение = Неопределено, Знач Договор = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(Договор) Тогда
					
		НаправлениеДеятельности = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "НаправлениеДеятельности");
		
	ИначеЕсли ЗначениеЗаполнено(Соглашение) Тогда
		
		НаправлениеДеятельности = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Соглашение, "НаправлениеДеятельности");
		
	КонецЕсли;
		
КонецПроцедуры

// Определяет обязательность указания направления деятельности по хозяйственной операции.
//
// Параметры:
//  ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Хозяйственная операция документа.
//
// Возвращаемое значение:
// 		Булево - Истина, если указание направления обязательно для переданной хозяйственной операции.
//
Функция УказаниеНаправленияДеятельностиОбязательно(ХозяйственнаяОперация) Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("ФормироватьФинансовыйРезультат") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ЭтоДоходнаяОперация 		= ХозяйственнаяОперацияОбразуетДоход(ХозяйственнаяОперация);
	ЭтоОперацияОбразующаяАктив 	= ХозяйственнаяОперацияОбразуетАктив(ХозяйственнаяОперация);
	ОбязательныйУчетДоходов 	= Ложь;
	ОбязательныйУчетЗатрат		= Ложь;
	
	Если ЭтоДоходнаяОперация И ОбязательныйУчетДоходов Тогда
		Возврат Истина;
	ИначеЕсли ЭтоОперацияОбразующаяАктив И ОбязательныйУчетЗатрат Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Определяет образует ли хозяйственная операция доход
//
// Параметры:
//  ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Хозяйственная операция документа или договора.
//
// Возвращаемое значение:
// 		Булево - Истина, если образуется доход.
//
Функция ХозяйственнаяОперацияОбразуетДоход(ХозяйственнаяОперация) Экспорт
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияКлиенту
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияКлиентуРеглУчет
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияКомиссионногоТовара
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияВРозницу
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОтгрузкаБезПереходаПраваСобственности
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОтКомиссионера
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОтРозничногоПокупателя
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратТоваровОтКлиента 
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссию
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОтчетКомиссионера
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОтчетКомиссионераОСписании
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПроизводствоИзДавальческогоСырья
		//Интеркампани
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссиюВДругуюОрганизацию 
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияТоваровВДругуюОрганизацию
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратПоКомиссииМеждуОрганизациями 
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратТоваровМеждуОрганизациями
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОтчетПоКомиссииМеждуОрганизациями
		
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратОплатыКлиенту
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзДругойОрганизации
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствВДругуюОрганизацию Тогда
		
		Возврат Истина;
	
	Иначе
	
		Возврат Ложь;
	
	КонецЕсли;

КонецФункции

// Определяет образует ли хозяйственная операция актив
//
// Параметры:
//  ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Хозяйственная операция документа или договора.
//
// Возвращаемое значение:
// 		Булево - Истина, если образуется актив.
//
Функция ХозяйственнаяОперацияОбразуетАктив(ХозяйственнаяОперация) Экспорт
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПриемНаКомиссию
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщикаТоварыВПути
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщикаФактуровкаПоставки
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщикаРеглУчет
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаЧерезПодотчетноеЛицо 
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпорту
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаПоИмпортуТоварыВПути
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭС
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭСТоварыВПути
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭСФактуровкаПоставки
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратТоваровКомитенту
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратТоваровПоставщику
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОформлениеГТДБрокером
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОформлениеГТДСамостоятельно 
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПроизводствоУПереработчика
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПриемНаКомиссию
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОтчетКомитенту
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОтчетКомитентуОСписании
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыкупТоваровХранящихсяНаСкладе
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыкупТоваровПереданныхВПроизводство
		
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СписаниеТоваровПоТребованию
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаВЭксплуатацию
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.Ремонт
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.Модернизация
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаПереработчику
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеОтПереработчика
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РазборкаТоваров
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПоступлениеИзПроизводства
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратИзЭксплуатации
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СторноСписанияНаРасходы
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПрочееПоступлениеТоваров
		
		
		
		//Интеркампани
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаНаКомиссиюВДругуюОрганизацию 
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеализацияТоваровВДругуюОрганизацию
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратПоКомиссииМеждуОрганизациями 
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратТоваровМеждуОрганизациями
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОтчетПоКомиссииМеждуОрганизациями 
		
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОплатаПоставщику
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтПоставщика
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОплатаДенежныхСредствВДругуюОрганизацию
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВозвратДенежныхСредствОтДругойОрганизации Тогда
		
		Возврат Истина;
	
	Иначе
	
		Возврат Ложь;
	
	КонецЕсли;

КонецФункции

// Устанавливает видимость направления деятельности по порядку расчетов документа.
//
// Параметры:
//	Форма - УправляемаяФорма - Форма, в которой было находится элемент группы финансового учета.
//	ЭтоЗаказ - Булево - Истина - Документ является заказом.
//	ПоЗаказу - Булево - Истина - Документ введен на основании заказа/заказов.
//
Процедура УстановитьВидимостьНаправленияДеятельности(Форма, ЭтоЗаказ = Ложь, ПоЗаказу = Ложь) Экспорт
	
	ВидимостьЭлемента = Ложь;
	ПорядокРасчетов = Форма.Объект.ПорядокРасчетов;
	
	Если ЭтоЗаказ Тогда
		ВидимостьЭлемента = (ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоЗаказамНакладным);
	ИначеЕсли ПоЗаказу Тогда
		ВидимостьЭлемента = (ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПоНакладным)
	Иначе
		ВидимостьЭлемента = (ПорядокРасчетов <> Перечисления.ПорядокРасчетов.ПоДоговорамКонтрагентов);
	КонецЕсли;
	
	Форма.Элементы.НаправлениеДеятельности.Видимость = ВидимостьЭлемента;
	
КонецПроцедуры

// Определяет, порядок формирования назначения при фиксации обособленных потребностей в заказах по данному направлению деятельности.
//
// Параметры:
//  Ссылка - СправочникСсылка.НаправленияДеятельности - направление деятельности, которое может быть указано в заказе.
//
// Возвращаемое значение:
//  Булево - Истина, если данное направление деятельности будет использоваться в аналитике обосоленной потребности заказа, Ложь - в противном случае.
//
Функция ЭтоНаправлениеДеятельностиСОбособлениемТоваровИРабот(Ссылка) Экспорт
	
	Результат = Ложь;
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		ВариантОбособления = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ВариантОбособления");
		Результат = ЗначениеЗаполнено(ВариантОбособления);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Определяет вариант обособления направления деятельности
//
// Параметры:
//  Ссылка - СправочникСсылка.НаправленияДеятельности - направление деятельности.
// 
// Возвращаемое значение:
//   - Булево - Истина, если передано толкающее направление деятельности
//
Функция ЭтоТолкающееНаправлениеДеятельности(Ссылка) Экспорт
	
	Результат = Ложь;
	
	Если ЗначениеЗаполнено(Ссылка) Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		ВариантОбособления = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ВариантОбособления");
		УстановитьПривилегированныйРежим(Ложь);
		
		Если ВариантОбособления = Перечисления.ВариантыОбособленияПоНаправлениюДеятельности.ПоНаправлениюВЦелом Тогда
			Результат = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Конструктор структуры по умолчанию для использования в функциях ОписаниеФормыДокументаДляЗаполненияРеквизитовСвязанныхСНаправлениемДеятельности
// модулей менеджеров документов.
//
// Возврашаемое значение:
//  Структура - структура с полями:
//   *ОформляетсяПоЗаказу - признак, что строки табличных частей могут быть оформлены по заказу.
//   *ЭтоИсточникПотребности - признак, что документ является документом фиксации обособленной потребности (заказом).
//   *ЕстьНазначениеВТЧ - признак, что в строках табличных частей есть реквизит назначение.
//   *ВТЧНазначениеОтгрузки - признак, что в строках табличных частей реквизит назначение используется для указания назначения отгружаемых товаров и работ, а не принимаемых).
//   *ТабЧасти - описание табличной части документа, используется для переопределения общих параметров, заданных для всех табличных частей.
//
Функция СтруктураОбъекта() Экспорт
	
	ФильтрХозОперация = Новый Массив();
	ФильтрХозОперация.Добавить("ОТГРУЗКА");
	ФильтрХозОперация.Добавить("ПОСТУПЛЕНИЕ");
	ОписаниеТабЧасти = Новый Структура("ФильтрХозОперация, ОформляетсяПоЗаказу", ФильтрХозОперация, Истина);
	
	ТабЧасти = Новый Структура();
	ТабЧасти.Вставить("Товары", ОписаниеТабЧасти);
	
	СтруктураОбъекта = Новый Структура();
	СтруктураОбъекта.Вставить("ТабЧасти", ТабЧасти);
	СтруктураОбъекта.Вставить("ОформляетсяПоЗаказу", Истина);
	СтруктураОбъекта.Вставить("ЭтоИсточникПотребности", Ложь);
	СтруктураОбъекта.Вставить("ЕстьНазначениеВТЧ", Истина);
	СтруктураОбъекта.Вставить("ВТЧНазначениеОтгрузки", Ложь);
	
	Возврат СтруктураОбъекта;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьЗаполнитьНазначенияСтрокахКоллекции(Массив, НаправлениеДеятельности)
	
	Таблица = Новый ТаблицаЗначений();
	Таблица.Колонки.Добавить("Назначение", Новый ОписаниеТипов("СправочникСсылка.Назначения"));
	Таблица.Колонки.Добавить("Индекс",     Новый ОписаниеТипов("Число"));
	Для Индекс = 0 По Массив.ВГраница() Цикл
		
		НоваяСтрока = Таблица.Добавить();
		НоваяСтрока.Индекс = Индекс;
		НоваяСтрока.Назначение = Массив[Индекс].Назначение;
		
	КонецЦикла;
	
	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Таблица.Индекс     КАК Индекс,
		|	Таблица.Назначение КАК Назначение
		|ПОМЕСТИТЬ ВтТаблица
		|ИЗ
		|	&Таблица КАК Таблица
		|;
		|
		|////////////////////////////////////
		|ВЫБРАТЬ
		|	Таблица.Индекс            КАК Индекс,
		|	СпрНаправления.Назначение КАК Назначение
		|ИЗ
		|	ВтТаблица КАК Таблица
		|		
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Назначения КАК СпрНазначения
		|		ПО СпрНазначения.Ссылка = Таблица.Назначение
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НаправленияДеятельности КАК СпрНаправления
		|		ПО СпрНаправления.Ссылка = &НаправлениеДеятельности
		|
		|ГДЕ
		|	ЕСТЬNULL(СпрНазначения.НаправлениеДеятельности,
		|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка)) <> ЕСТЬNULL(СпрНаправления.Ссылка, ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка))
		|	И Таблица.Назначение <> ЕСТЬNULL(СпрНаправления.Назначение, ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка))";
		
	Запрос.УстановитьПараметр("НаправлениеДеятельности", НаправлениеДеятельности);
	Запрос.УстановитьПараметр("Таблица",                 Таблица);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Массив[Выборка.Индекс].Назначение = Выборка.Назначение;
	КонецЦикла;
	
КонецПроцедуры

Функция НайтиСтрокиВКоллекциях(Форма, СтруктураОбъекта, ХозОперация, УсловияОтбора)
	
	ИменаТабЧастей = ИменаТабЧастейПоХозОперации(Форма, СтруктураОбъекта, ХозОперация);
	
	НайденныеСтроки = Новый Массив();
	Для Каждого ИмяТабЧасти Из ИменаТабЧастей Цикл
		
		Поля = КолонкиТабЧастиДляПроверкиУсловий(СтруктураОбъекта, ИмяТабЧасти, УсловияОтбора);
		Для Каждого СтрокаТЧ Из Форма.Объект[ИмяТабЧасти] Цикл
			
			Если УдовлетворяетОтбору(СтрокаТЧ, УсловияОтбора, Поля) Тогда
				
				НайденныеСтроки.Добавить(СтрокаТЧ);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат НайденныеСтроки;
	
КонецФункции

Функция НаправленияДеятельностиКэшированныеЗначения()
	
	КэшированныеЗначения = Новый Структура();
	КэшированныеЗначения.Вставить("ИспользоватьНаправленияДеятельности");
	КэшированныеЗначения.Вставить("ИспользоватьОбособленноеОбеспечениеЗаказов");
	КэшированныеЗначения.Вставить("НазначениеПоУмолчанию");
	Возврат КэшированныеЗначения;
	
КонецФункции

Функция КолонкиТабЧастиДляПроверкиУсловий(СтруктураОбъекта, ИмяТабЧасти, УсловияОтбора)
	
	Поля = Новый Массив();
	Для Каждого Колонка Из УсловияОтбора.Колонки Цикл
		
		ДобавлятьКолонку = Истина;
		ИмяПоля = Колонка.Имя;
		
		Если ИмяПоля = "КодСтроки" Тогда
			
			Если Не СтруктураОбъекта.ОформляетсяПоЗаказу Или Не СтруктураОбъекта.ТабЧасти[ИмяТабЧасти].ОформляетсяПоЗаказу Тогда
				ДобавлятьКолонку = Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ДобавлятьКолонку Тогда
			Поля.Добавить(ИмяПоля);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Поля;
	
КонецФункции

Функция УдовлетворяетОтбору(ПроверяемоеЗначение, УсловияОтбора, Поля)
	
	Для Каждого Условие Из УсловияОтбора Цикл
		
		Результат = Истина;
		Для Каждого ИмяПоля Из Поля Цикл
			
			Если ПроверяемоеЗначение[ИмяПоля] <> Условие[ИмяПоля] Тогда
				
				Результат = Ложь;
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если Результат Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЦикла;
	Возврат Ложь;
	
КонецФункции

Функция ИменаТабЧастейПоХозОперации(Форма, СтруктураОбъекта, ХозОперация)
	
	Результат = Новый Массив();
	Для Каждого ТабЧасть Из СтруктураОбъекта.ТабЧасти Цикл
		
		Если ТабЧасть.Значение.ФильтрХозОперация.Найти(ХозОперация) <> Неопределено Тогда
			
			Результат.Добавить(ТабЧасть.Ключ);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#Область УсловноеОформление

// Устанавливает условное для реквизита НаправлениеДеятельности.
//
// Параметры:
//	Форма - УправляемаяФорма - форма, для которой настраивается условное оформление.
//
Процедура УстановитьУсловноеОформлениеНаправленияДеятельности(Форма) Экспорт
	
	//
	Элемент = Форма.УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Форма.Элементы.НаправлениеДеятельности.Имя);

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НаправлениеДеятельностиОбязательно");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.НаправлениеДеятельности");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Истина);
	
	//
	Элемент = Форма.УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Форма.Элементы.НаправлениеДеятельности.Имя);

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НаправлениеДеятельностиОбязательно");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.НаправлениеДеятельности");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти




