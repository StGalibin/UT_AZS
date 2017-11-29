﻿////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы Библиотеки Интеграции с ЕГАИС (БЕГАИС).
// 
/////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Сведения о библиотеке (или конфигурации).

// Заполняет основные сведения о библиотеке или основной конфигурации.
// Библиотека, имя которой имя совпадает с именем конфигурации в метаданных, определяется как основная конфигурация.
// 
// Параметры:
//  Описание - Структура - сведения о библиотеке:
//
//   * Имя                 - Строка - имя библиотеки, например, "СтандартныеПодсистемы".
//   * Версия              - Строка - версия в формате из 4-х цифр, например, "2.1.3.1".
//
//   * ТребуемыеПодсистемы - Массив - имена других библиотек (Строка), от которых зависит данная библиотека.
//                                    Обработчики обновления таких библиотек должны быть вызваны ранее
//                                    обработчиков обновления данной библиотеки.
//                                    При циклических зависимостях или, напротив, отсутствии каких-либо зависимостей,
//                                    порядок вызова обработчиков обновления определяется порядком добавления модулей
//                                    в процедуре ПриДобавленииПодсистем общего модуля
//                                    ПодсистемыКонфигурацииПереопределяемый.
//
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Имя    = "БиблиотекаИнтеграцииЕГАИС";
	Описание.Версия = ИнтеграцияЕГАИСКлиентСервер.ВерсияПодсистемыЕГАИС();
	Описание.РежимВыполненияОтложенныхОбработчиков = "Параллельно";
	
	Описание.ТребуемыеПодсистемы.Добавить("СтандартныеПодсистемы");
	Описание.ТребуемыеПодсистемы.Добавить("БиблиотекаПодключаемогоОборудования");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления информационной базы.

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - описание полей, см. в процедуре.
//                ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления.
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.Версия              = "1.1.0.0";
//  Обработчик.Процедура           = "ОбновлениеИБ.ПерейтиНаВерсию_1_1_0_0";
//  Обработчик.РежимВыполнения     = "Монопольно";
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	
	
КонецПроцедуры

// Вызывается перед процедурами-обработчиками обновления данных ИБ.
//
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
	ВерсияКонфигурации = ОбновлениеИнформационнойБазы.ВерсияИБ(Метаданные.Имя);
	Если ВерсияКонфигурации <> "0.0.0.0" Тогда
		
		ИдентификаторБиблиотекаИнтеграцииЕГАИС = "БиблиотекаИнтеграцииЕГАИС";
		ВерсияБиблиотекаИнтеграцииЕГАИС = ОбновлениеИнформационнойБазы.ВерсияИБ(ИдентификаторБиблиотекаИнтеграцииЕГАИС);
		Если ВерсияБиблиотекаИнтеграцииЕГАИС = "0.0.0.0" Тогда
			
			ОбновлениеИнформационнойБазы.УстановитьВерсиюИБ("БиблиотекаИнтеграцииЕГАИС", "1.0.0.0", Ложь);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Вызывается после завершения обновления данных ИБ.
// 
// Параметры:
//   ПредыдущаяВерсия       - Строка - версия до обновления. "0.0.0.0" для "пустой" ИБ.
//   ТекущаяВерсия          - Строка - версия после обновления.
//   ВыполненныеОбработчики - ДеревоЗначений - список выполненных процедур-обработчиков обновления,
//                                             сгруппированных по номеру версии.
//   ВыводитьОписаниеОбновлений - Булево - если установить Истина, то будет выведена форма
//                                с описанием обновлений. По умолчанию, Истина.
//                                Возвращаемое значение.
//   МонопольныйРежим           - Булево - Истина, если обновление выполнялось в монопольном режиме.
//
// Пример обхода выполненных обработчиков обновления:
//
//	Для Каждого Версия Из ВыполненныеОбработчики.Строки Цикл
//		
//		Если Версия.Версия = "*" Тогда
//			// Обработчик, который может выполнятся при каждой смене версии.
//		Иначе
//			// Обработчик, который выполняется для определенной версии.
//		КонецЕсли;
//		
//		Для Каждого Обработчик Из Версия.Строки Цикл
//			...
//		КонецЦикла;
//		
//	КонецЦикла;
//
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
		Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
	
КонецПроцедуры

// Вызывается при подготовке табличного документа с описанием изменений в программе.
//
// Параметры:
//   Макет - ТабличныйДокумент - описание обновления всех библиотек и конфигурации.
//           Макет можно дополнить или заменить.
//           См. также общий макет ОписаниеИзмененийСистемы.
//
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	
КонецПроцедуры

// Позволяет переопределить режим обновления данных информационной базы.
// Для использования в редких (нештатных) случаях перехода, не предусмотренных в
// стандартной процедуре определения режима обновления.
//
// Параметры:
//   РежимОбновленияДанных - Строка - в обработчике можно присвоить одно из значений:
//              "НачальноеЗаполнение"     - если это первый запуск пустой базы (области данных);
//              "ОбновлениеВерсии"        - если выполняется первый запуск после обновление конфигурации базы данных;
//              "ПереходСДругойПрограммы" - если выполняется первый запуск после обновление конфигурации базы данных, 
//                                          в которой изменилось имя основной конфигурации.
//
//   СтандартнаяОбработка  - Булево - если присвоить Ложь, то стандартная процедура
//                                    определения режима обновления не выполняется, 
//                                    а используется значение РежимОбновленияДанных.
//
Процедура ПриОпределенииРежимаОбновленияДанных(РежимОбновленияДанных, СтандартнаяОбработка) Экспорт
 
КонецПроцедуры

// Добавляет в список процедуры-обработчики перехода с другой программы (с другим именем конфигурации).
// Например, для перехода между разными, но родственными конфигурациями: базовая -> проф -> корп.
// Вызывается перед началом обновления данных ИБ.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - с колонками:
//    * ПредыдущееИмяКонфигурации - Строка - имя конфигурации, с которой выполняется переход;
//                                           или "*", если нужно выполнять при переходе с любой конфигурации.
//    * Процедура                 - Строка - полное имя процедуры-обработчика перехода с программы ПредыдущееИмяКонфигурации. 
//                                  Например, "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику"
//                                  Обязательно должна быть экспортной.
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.ПредыдущееИмяКонфигурации  = "УправлениеТорговлей";
//  Обработчик.Процедура                  = "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику";
//
Процедура ПриДобавленииОбработчиковПереходаСДругойПрограммы(Обработчики) Экспорт
 
КонецПроцедуры

// Вызывается после выполнения всех процедур-обработчиков перехода с другой программы (с другим именем конфигурации),
// и до начала выполнения обновления данных ИБ.
//
// Параметры:
//  ПредыдущееИмяКонфигурации    - Строка - имя конфигурации до перехода.
//  ПредыдущаяВерсияКонфигурации - Строка - имя предыдущей конфигурации (до перехода).
//  Параметры                    - Структура - 
//    * ВыполнитьОбновлениеСВерсии   - Булево - по умолчанию Истина. Если установить Ложь, 
//        то будут выполнена только обязательные обработчики обновления (с версией "*").
//    * ВерсияКонфигурации           - Строка - номер версии после перехода. 
//        По умолчанию, равен значению версии конфигурации в свойствах метаданных.
//        Для того чтобы выполнить, например, все обработчики обновления с версии ПредыдущаяВерсияКонфигурации, 
//        следует установить значение параметра в ПредыдущаяВерсияКонфигурации.
//        Для того чтобы выполнить вообще все обработчики обновления, установить значение "0.0.0.1".
//    * ОчиститьСведенияОПредыдущейКонфигурации - Булево - по умолчанию Истина. 
//        Для случаев когда предыдущая конфигурация совпадает по имени с подсистемой текущей конфигурации, следует указать Ложь.
//
Процедура ПриЗавершенииПереходаСДругойПрограммы(Знач ПредыдущееИмяКонфигурации, Знач ПредыдущаяВерсияКонфигурации, Параметры) Экспорт
 
КонецПроцедуры

#КонецОбласти

#Область МеханизмОтложенногоПроведения

// Результат адаптации запроса для фукнции ОбновлениеИнформационнойБазыЕГАИС.РегистраторыДляПерепроведения
// 
// Возвращаемое значение:
//  Структура - поля:
//	* ТекстЗапроса - Строка - должен быть объявлен обязательно, адаптированный текст запроса
//	* ЗначенияПараметров - Структура - значения параметров запроса, которые вычисляются из констант
//										(не зависят от конкретного документа)
//
Функция РезультатАдаптацииЗапроса() Экспорт
	
	РезультатАдаптацииЗапроса = Новый Структура;
	РезультатАдаптацииЗапроса.Вставить("ТекстЗапроса");
	РезультатАдаптацииЗапроса.Вставить("ЗначенияПараметров", Новый Структура);
	
	Возврат РезультатАдаптацииЗапроса;
КонецФункции

// Адаптирует запрос механизма проведения для использования в функции ОбновлениеИнформационнойБазыЕГАИС.РегистраторыДляПерепроведения,
// делая его запросом для всех проведенных документов.
// Параметры:
//  ИзначальныйТекстЗапроса - Строка - текст запроса механизма проведения, который или формирует таблицу движений, или создает временные таблицы,
//												используемые в запросах формирующих таблицы движений
//												Требования к тексту запроса:
//												- все объединяемые таблицы запроса, формирующего таблицу движений имеют один синоним;
//												- если есть соедининения с другими таблицами, то оно реализовано таким образом, что будет
//													корректно работать, если не установлен отбор по ссылке;
//												- не используются временные таблицы;
//												- не используются вложенные запросы и группировки;
//												- нет упорядочивания;
//												- параметры запроса рассчитываются или по данным шапки, или являются значениями констант;
// 												- для всех полей непримитивных типов заполнены значения по умолчанию, как они хранятся в регистре.
//													Это или пустая ссылка типа, или НЕОПРЕДЕЛЕНО (для полей составного типа), то НЕ должно быть NULL
//												- параметр, устанавливающий отбор по ссылке называется &Ссылка
//												- в конце запроса не должно быть знака ";"
// 												- в тексте запроса, формирующим таблицу движения, должны выбираться только ЗНАЧИМЫЕ
//													для формирования движений поля (нет полей НомерСтроки, Порядок и т.д.);
//  ПолноеИмяРегистра				 - Строка - полное имя регистра, как оно задается в языке запросов (например, РегистрНакопления.ТоварыНаСкладах)
//  ПолноеИмяДокумента				 - Строка - полное имя документа, как оно задается в языке запросов (например, Документ.ВводОстатков)
//  СинонимТаблицыДокумента			 - Строка - синоним таблицы документа, используемый в запросе
//  ПереопределениеРасчетаПараметров - Структура - по умолчанию все параметры, которые есть в запросе заменяются на <СинонимТаблицыДокумента>.Ссылка.<ИмяПараметра>
//  												Для параметра &Период по умолчанию подставляется <СинонимТаблицыДокумента>.Ссылка.Дата
//  												Если параметры расчитываются иначе, то в этой структуре в ключе передается имя параметра, в значении
//													- выражение для его расчета
//  ТекстыЗапросаВременныхТаблиц     - Соответствие - тексты запросов временных таблиц, используемых в тексте запроса механизма проведения.
//													  Ключ соответствия - имя временной таблицы, Значение - текст запроса временной таблицы.
//													  Параметр необходимо использовать когда механизм формирования движений опирается не на
//													  физическую таблицу документа, а на предварительно созданную временную таблицу.
//													  Поля выборки временной таблицы должны содержать поле "Ссылка" - ссылку на физическую таблицу проводимого документа.
//
// Возвращаемое значение:
//   - строка - адаптированный текст запроса
//
Функция АдаптироватьЗапросМеханизмаПроведения(Знач ИзначальныйТекстЗапроса,
														ПолноеИмяДокумента,
														СинонимТаблицыДокумента,
														ПереопределениеРасчетаПараметров,
														ТекстыЗапросаВременныхТаблиц = Неопределено) Экспорт
	
	ИзначальныйТекстЗапроса = СтрЗаменить(ИзначальныйТекстЗапроса,
										"ВЫБРАТЬ",
										"ВЫБРАТЬ
										|	ТаблицаДокументаОбновлениеИБ.Ссылка КАК Регистратор,");
				
	ИзначальныйТекстЗапроса = СтрЗаменить(ИзначальныйТекстЗапроса,
										"ГДЕ",
										"
										|ГДЕ
										|	ТаблицаДокументаОбновлениеИБ.Ссылка.Проведен
										|	И ");
	
	Если ТекстыЗапросаВременныхТаблиц <> Неопределено Тогда
		
		Для Каждого Элемент Из ТекстыЗапросаВременныхТаблиц Цикл
			
			ПревыйСимвол = СтрНайти(Элемент.Значение, "ПОМЕСТИТЬ");
			ПоследнийСимвол = СтрНайти(Элемент.Значение, Элемент.Ключ, НаправлениеПоиска.СНачала, ПревыйСимвол) + СтрДлина(Элемент.Ключ);
			ПодстановкаПоиска = Сред(Элемент.Значение, ПревыйСимвол, ПоследнийСимвол - ПревыйСимвол);
			ПодстановкаВременнойТаблицы = СтрЗаменить(Элемент.Значение, ПодстановкаПоиска, "");
			ИзначальныйТекстЗапроса = СтрЗаменить(ИзначальныйТекстЗапроса, Элемент.Ключ, "(" + ПодстановкаВременнойТаблицы + ")");
			
		КонецЦикла;
		
	КонецЕсли;
	
	ИзначальныйТекстЗапроса = СтрЗаменить(ИзначальныйТекстЗапроса,СинонимТаблицыДокумента,"ТаблицаДокументаОбновлениеИБ");
	ИзначальныйТекстЗапроса = СтрЗаменить(ИзначальныйТекстЗапроса,"ТаблицаДокументаОбновлениеИБ.Ссылка = &Ссылка","ИСТИНА");
	
	Запрос = Новый Запрос;
	Запрос.Текст = ИзначальныйТекстЗапроса;
	
	ПараметрыЗапроса = Запрос.НайтиПараметры();
	МетаданныеДокумента = Метаданные.НайтиПоПолномуИмени(ПолноеИмяДокумента);
	
	Для Каждого Параметр из ПараметрыЗапроса Цикл
		
		ТекстЗамены = Неопределено;
		
		Если ПереопределениеРасчетаПараметров.Свойство(Параметр.Имя) Тогда
			ТекстЗамены = ПереопределениеРасчетаПараметров[Параметр.Имя];
			ТекстЗамены = СтрЗаменить(ТекстЗамены, СинонимТаблицыДокумента, "ТаблицаДокументаОбновлениеИБ");
		ИначеЕсли Параметр.Имя = "Ссылка" Тогда
			ТекстЗамены = "ТаблицаДокументаОбновлениеИБ.Ссылка";
		ИначеЕсли Параметр.Имя = "Период" Тогда
			ТекстЗамены = "ТаблицаДокументаОбновлениеИБ.Ссылка.Дата";
		ИначеЕсли МетаданныеДокумента.Реквизиты.Найти(Параметр.Имя) <> Неопределено Тогда
			ТекстЗамены = "ТаблицаДокументаОбновлениеИБ.Ссылка." + Параметр.Имя;
		КонецЕсли;	
		
		Если ТекстЗамены <> Неопределено Тогда
			ИзначальныйТекстЗапроса = СтрЗаменить(ИзначальныйТекстЗапроса,"&" + Параметр.Имя, ТекстЗамены);
		КонецЕсли;
			
	КонецЦикла;
	
	Возврат ИзначальныйТекстЗапроса;
	
КонецФункции

// Выбирает регистраторы, по которым движения записанные в регистр отличаются от тех, которые формируются запросом механизма проведения
// Параметры:
//  РезультатАдаптацииЗапроса - Структура - см. ОбновлениеИнформационнойБазыЕГАИС.РезультатАдаптацииЗапроса 
// 												Требования к запросам:
// 												- текст не должен содержать обращения к временным таблицам
//												- все запросы должны быть адаптированы для выборки без отбора по ссылке.
//													это можно сделать  с помощью фукнции ОбновлениеИнформационнойБазыЕГАИС.АдаптироватьЗапросМеханизмаПроведения, 
//													 если текст запроса удовлетворяет ее условиям. Если нет - можно попробовать адаптировать текст самостоятельно
// 												- в тексте запроса, формирующим таблицу движения, должны выбираться только ЗНАЧИМЫЕ
//													для формирования движений поля (нет полей НомерСтроки, Порядок и т.д.);
// 												- нет упорядочивания; 
// 												- есть поле "Регистратор"; 
//  ПолноеИмяРегистра				 - Строка - полное имя регистра, как оно задается в языке запросов (например, РегистрНакопления.ТоварыНаСкладах)
//  ПолноеИмяДокумента				 - Строка - полное имя документа, как оно задается в языке запросов (например, Документ.ВводОстатков)
//  ЗначенияПараметров - Структура - если параметры не рассчитываются в запросе, а устанавливаются из кода, то в этом параметре нужно передать их значения
//									Например, это значения учитываемых ФО
//  Очередь - Число, Неопределено - если параметр <> Неопределено, то при составлении массива регистраторов учитывается информация о выполнении обработчиков обновления
//										- исключаются регистраторы, которые не обновлены обработчиками предыдущих очередей
//										- оптимизируется выборка данных, т.к. берутся только те регистраторы, которые еще не обрабатывались в текущей очереди
//									Важно, чтобы тексты запросов адаптировались тоже с учетом очереди (либо тоже без учета очереди)
// Возвращаемое значение:
//   - Массив - массив ссылок на документы, по которым нужно переформировать движения по регистру
//
Функция РегистраторыДляПерепроведения(РезультатАдаптацииЗапроса,
										ПолноеИмяРегистра,
										ПолноеИмяДокумента) Экспорт
	
	Очередь = Неопределено;
	ТекстЗапросаФормированияДвижений = РезультатАдаптацииЗапроса.ТекстЗапроса;
	ЗначенияПараметров = РезультатАдаптацииЗапроса.ЗначенияПараметров;
	
	ТекстРезультирующегоЗапроса = "";
	
	ЧастиИмениРегистра = СтрРазделить(ПолноеИмяРегистра, ".", Ложь);
	
	ТипРегистра = ЧастиИмениРегистра[0];
	ИмяРегистра = ЧастиИмениРегистра[1];
	
	Если ТипРегистра = "РегистрНакопления"
		Или ТипРегистра = "РегистрСведений" Тогда
		МетаданныеРегистра = Метаданные.НайтиПоПолномуИмени(ПолноеИмяРегистра);
	Иначе
		ТекстИсключения = НСтр("ru = 'Функция не поддерживает работу с регистрами типа %ТипРегистра%.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ТипРегистра%", ТипРегистра);
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
		
	ТекстРегистра = 
	"ВЫБРАТЬ";
	
	ТекстВыборкиСуммирующегоЗапроса =
	"ВЫБРАТЬ";
	ТекстГруппировкиСуммирующиегоЗапроса = "
	|СГРУППИРОВАТЬ ПО";
	ТекстУсловияСуммирующиегоЗапроса = "
	|ИМЕЮЩИЕ
	|	ЛОЖЬ";
	
	Если ТипРегистра = "РегистрСведений" Тогда
		ТекстЗапросаФормированияДвижений = СтрЗаменить(ТекстЗапросаФормированияДвижений,
											"ВЫБРАТЬ",
											"ВЫБРАТЬ
											|	1 КАК КонтрольноеПолеОбновлениеИБ,");
		ТекстРегистра = СтрЗаменить(ТекстРегистра,
											"ВЫБРАТЬ",
											"ВЫБРАТЬ
											|	-1,");
		ТекстВыборкиСуммирующегоЗапроса = СтрЗаменить(ТекстВыборкиСуммирующегоЗапроса,
											"ВЫБРАТЬ",
											"ВЫБРАТЬ
											|	СУММА(КонтрольноеПолеОбновлениеИБ) КАК КонтрольноеПолеОбновлениеИБ,");
		ТекстУсловияСуммирующиегоЗапроса = ТекстУсловияСуммирующиегоЗапроса + "
		| ИЛИ СУММА(КонтрольноеПолеОбновлениеИБ) <> 0";
	КонецЕсли;				
	
	
	СхемаЗапроса = Новый СхемаЗапроса;
	СхемаЗапроса.УстановитьТекстЗапроса(ТекстЗапросаФормированияДвижений);
	
	Запрос = СхемаЗапроса.ПакетЗапросов[0];
	
	ВсеКолонки = Новый Массив;
	
	Для каждого Колонка из Запрос.Колонки Цикл
		
		ВсеКолонки.Добавить(Колонка.Псевдоним);
		
		Если ТипРегистра = "РегистрНакопления"
			И МетаданныеРегистра.Ресурсы.Найти(Колонка.Псевдоним) <> Неопределено Тогда		
			
			ТекстРегистра = ТекстРегистра + "
			|	-ТаблицаРегистра." + Колонка.Псевдоним + ",";
			
			ТекстВыборкиСуммирующегоЗапроса = ТекстВыборкиСуммирующегоЗапроса + "
			|	СУММА(ВложенныйЗапрос." + Колонка.Псевдоним + ") КАК " + Колонка.Псевдоним + ",";
			
			ТекстУсловияСуммирующиегоЗапроса = ТекстУсловияСуммирующиегоЗапроса + "
			|	ИЛИ СУММА(ВложенныйЗапрос." + Колонка.Псевдоним + ") <> 0";
			
		ИначеЕсли Не Колонка.Псевдоним = "КонтрольноеПолеОбновлениеИБ" Тогда
			ТекстРегистра = ТекстРегистра + "
			|	ТаблицаРегистра." + Колонка.Псевдоним + ",";
			
			ТекстВыборкиСуммирующегоЗапроса = ТекстВыборкиСуммирующегоЗапроса + "
			|	ВложенныйЗапрос." + Колонка.Псевдоним + " КАК " + Колонка.Псевдоним + ",";
			
			ТекстГруппировкиСуммирующиегоЗапроса = ТекстГруппировкиСуммирующиегоЗапроса + " 
			|	ВложенныйЗапрос." + Колонка.Псевдоним + ",";
		КонецЕсли;
				
	КонецЦикла;
	
	ТекстВставкиЗапросФормирующийДвижения = "";
	
	Для каждого Измерение из МетаданныеРегистра.Измерения Цикл
		
		Если ВсеКолонки.Найти(Измерение.Имя) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ТекстРегистра = ТекстРегистра + "
		|	ТаблицаРегистра." + Измерение.Имя + ",";
		
		ТекстВыборкиСуммирующегоЗапроса = ТекстВыборкиСуммирующегоЗапроса + "
		|	ВложенныйЗапрос." + Измерение.Имя + " КАК " + Измерение.Имя + ",";
		
		ТекстГруппировкиСуммирующиегоЗапроса = ТекстГруппировкиСуммирующиегоЗапроса + " 
		|	ВложенныйЗапрос." + Измерение.Имя + ",";
		
		ТекстВставкиЗапросФормирующийДвижения = ТекстВставкиЗапросФормирующийДвижения + "
		|	&ПустоеЗначение" + Измерение.Имя + " КАК " + Измерение.Имя + ",";
		
		ЗначенияПараметров.Вставить("ПустоеЗначение" + Измерение.Имя, Измерение.Тип.ПривестиЗначение());
		
	КонецЦикла;
	
	Для каждого Ресурс из МетаданныеРегистра.Ресурсы Цикл
		
		Если ВсеКолонки.Найти(Ресурс.Имя) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТипРегистра = "РегистрНакопления" Тогда
			ТекстРегистра = ТекстРегистра + "
			|	-ТаблицаРегистра." + Ресурс.Имя + ",";
			
			ТекстВыборкиСуммирующегоЗапроса = ТекстВыборкиСуммирующегоЗапроса + "
			|	СУММА(ВложенныйЗапрос." + Ресурс.Имя + ") КАК " + Ресурс.Имя + ",";
			
			ТекстУсловияСуммирующиегоЗапроса = ТекстУсловияСуммирующиегоЗапроса + "
			|	ИЛИ СУММА(ВложенныйЗапрос." + Ресурс.Имя + ") <> 0";
			
			ТекстВставкиЗапросФормирующийДвижения = ТекстВставкиЗапросФормирующийДвижения + "
			|	0 КАК " + Ресурс.Имя + ",";
		Иначе
			ТекстРегистра = ТекстРегистра + "
			|	ТаблицаРегистра." + Ресурс.Имя + ",";
			
			ТекстВыборкиСуммирующегоЗапроса = ТекстВыборкиСуммирующегоЗапроса + "
			|	ВложенныйЗапрос." + Ресурс.Имя + " КАК " + Ресурс.Имя + ",";
			
			ТекстГруппировкиСуммирующиегоЗапроса = ТекстГруппировкиСуммирующиегоЗапроса + " 
			|	ВложенныйЗапрос." + Ресурс.Имя + ",";
			
			ТекстВставкиЗапросФормирующийДвижения = ТекстВставкиЗапросФормирующийДвижения + "
			|	&ПустоеЗначение" + Ресурс.Имя + " КАК " + Ресурс.Имя + ",";
			
			ЗначенияПараметров.Вставить("ПустоеЗначение" + Ресурс.Имя, Ресурс.Тип.ПривестиЗначение());
		КонецЕсли;
	КонецЦикла;
	
	Для каждого Реквизит из МетаданныеРегистра.Реквизиты Цикл
		
		Если ВсеКолонки.Найти(Реквизит.Имя) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ТекстРегистра = ТекстРегистра + "
		|	ТаблицаРегистра." + Реквизит.Имя + ",";
		
		ТекстВыборкиСуммирующегоЗапроса = ТекстВыборкиСуммирующегоЗапроса + "
		|	ВложенныйЗапрос." + Реквизит.Имя + " КАК " + Реквизит.Имя + ",";
		
		ТекстГруппировкиСуммирующиегоЗапроса = ТекстГруппировкиСуммирующиегоЗапроса + " 
		|	ВложенныйЗапрос." + Реквизит.Имя + ",";
		
		ТекстВставкиЗапросФормирующийДвижения = ТекстВставкиЗапросФормирующийДвижения + "
		|	&ПустоеЗначение" + Реквизит.Имя + " КАК " + Реквизит.Имя + ",";
		
		ЗначенияПараметров.Вставить("ПустоеЗначение" + Реквизит.Имя, Реквизит.Тип.ПривестиЗначение());
		
	КонецЦикла;
	
	ТекстРегистра = Лев(ТекстРегистра, СтрДлина(ТекстРегистра) - 1);
	ТекстВыборкиСуммирующегоЗапроса = Лев(ТекстВыборкиСуммирующегоЗапроса, СтрДлина(ТекстВыборкиСуммирующегоЗапроса) - 1);
	ТекстГруппировкиСуммирующиегоЗапроса = Лев(ТекстГруппировкиСуммирующиегоЗапроса, СтрДлина(ТекстГруппировкиСуммирующиегоЗапроса) - 1);
	
	Если Не ПустаяСтрока(ТекстВставкиЗапросФормирующийДвижения) Тогда
		ТекстВставкиЗапросФормирующийДвижения = Лев(ТекстВставкиЗапросФормирующийДвижения, СтрДлина(ТекстВставкиЗапросФормирующийДвижения) - 1);
		ТекстЗапросаФормированияДвижений = СтрЗаменить(ТекстЗапросаФормированияДвижений,
											"ИЗ",
											",
											|" +ТекстВставкиЗапросФормирующийДвижения + "
											|ИЗ");
	КонецЕсли;
			
	ТекстРегистра = ТекстРегистра + "
	|ИЗ
	|	" + ПолноеИмяРегистра + " КАК ТаблицаРегистра";
	
	Если Очередь <> Неопределено Тогда
		ТекстРегистра = ТекстРегистра + "
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ " + ПолноеИмяРегистра + ".Изменения КАК РегистраторыКОбработке
		|		ПО ТаблицаРегистра.Регистратор = РегистраторыКОбработке.Регистратор
		|			И (РегистраторыКОбработке.Узел = &ТекущаяОчередь)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЗаблокированоРегистратор КАК ВТЗаблокированоРегистратор
		|		ПО ТаблицаРегистра.Регистратор = ВТЗаблокированоРегистратор.Регистратор
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЗаблокированоСсылка КАК ВТЗаблокированоСсылка
		|		ПО ТаблицаРегистра.Регистратор = ВТЗаблокированоСсылка.Ссылка";
	КонецЕсли;
	
	ТекстРегистра = ТекстРегистра + "
	|ГДЕ
	|	ТаблицаРегистра.Регистратор ССЫЛКА " + ПолноеИмяДокумента;
	
	Если Очередь <> Неопределено Тогда
		ТекстРегистра = ТекстРегистра + "
		|	И ВТЗаблокированоРегистратор.Регистратор ЕСТЬ NULL 
		|	И ВТЗаблокированоСсылка.Ссылка ЕСТЬ NULL ";
	КонецЕсли;
	
	ТекстРезультирующегоЗапроса = ТекстРезультирующегоЗапроса + "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НеправильныеДвижения.Регистратор КАК Регистратор
	|ИЗ
	|(" + ТекстВыборкиСуммирующегоЗапроса + "
	|ИЗ
	|	("
	+ ТекстЗапросаФормированияДвижений 
	+ "
	|ОБЪЕДИНИТЬ ВСЕ
	|" 
	+ ТекстРегистра
	+ ") КАК ВложенныйЗапрос "
	+ ТекстГруппировкиСуммирующиегоЗапроса
	+ ТекстУсловияСуммирующиегоЗапроса + ") КАК НеправильныеДвижения";
	
	ЗапросВыборки = Новый Запрос;
	
	Для Каждого Параметр из ЗначенияПараметров Цикл
		
		ЗапросВыборки.УстановитьПараметр(Параметр.Ключ, Параметр.Значение);
		
	КонецЦикла;
	
	Если Очередь <> Неопределено Тогда
		
		МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц();
		
		ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуЗаблокированныхДляЧтенияИИзмененияДанных(Очередь, ПолноеИмяДокумента, МенеджерВременныхТаблиц);
		ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуЗаблокированныхДляЧтенияИИзмененияДанных(Очередь, ПолноеИмяРегистра, МенеджерВременныхТаблиц);
	
		ТекстРезультирующегоЗапроса = СтрЗаменить(ТекстРезультирующегоЗапроса, "ВТЗаблокированоРегистратор","ВТЗаблокировано" + ИмяРегистра);
		ТекстРезультирующегоЗапроса = СтрЗаменить(ТекстРезультирующегоЗапроса, "ВТЗаблокированоСсылка","ВТЗаблокировано" + СтрРазделить(ПолноеИмяДокумента,".")[1]);
	
		ЗапросВыборки.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
		
		ЗапросВыборки.УстановитьПараметр("ТекущаяОчередь", ПланыОбмена.ОбновлениеИнформационнойБазы.УзелПоОчереди(Очередь));
		
	КонецЕсли;
	
	ЗапросВыборки.Текст = ТекстРезультирующегоЗапроса;
	
	Регистраторы = ЗапросВыборки.Выполнить().Выгрузить().ВыгрузитьКолонку("Регистратор");
	
	Возврат Регистраторы;
КонецФункции

// На основе данных о необходимости переформирования движений перезаписывает движения документа.
//	Для работы функции необходимо, чтобы процедура ИнициализироватьДанныеДокумента модуля менеджера документа, поддерживала параметр Регистры.
//	см. например, Документ.АктПостановкиНаБалансЕГАИС.ИнициализироватьДанныеДокумента
//
// Параметры:
//  ПолноеИмяДокумента					 - Строка, Массив - имя документа, по которому нужно переформировать движения. Например, "Документ.АктПостановкиНаБалансЕГАИС"
//																Если документов несколько, то нужно передать их имена в массиве.
//  ПолныеИменаРегистров				 - Строка, Массив - имя регистра, по которому нужно переформировать движения. Например, "РегистрНакопления.ОстаткиАлкогольнойПродукцииЕГАИС"
//																Если регистров несколько, то их имена нужно передать в массиве.
//  Очередь								 - Число - очередь отоженной обработки данных для контроля данных на предмет блокировки другими обработчиками
// 
// Возвращаемое значение:
//  Булево - ИСТИНА, если обработка всех движений завершена 
//
Функция ПерезаписатьДвиженияИзОчереди(ПолныеИменаДокументов, ПолныеИменаРегистров, Очередь) Экспорт
	
	Если ТипЗнч(ПолныеИменаДокументов) = Тип("Строка") Тогда
		СписокДокументов = СтрРазделить(ПолныеИменаДокументов, ",", Ложь);
	Иначе
		СписокДокументов = ПолныеИменаДокументов;
	КонецЕсли;
	
	Если ТипЗнч(ПолныеИменаРегистров) = Тип("Строка") Тогда
		Регистры = СтрРазделить(ПолныеИменаРегистров, ",", Ложь);
	Иначе
		Регистры = ПолныеИменаРегистров;
	КонецЕсли;
		
	ЕстьЕщеРабота = Ложь;
		
	Для Каждого ПолноеИмяДокумента Из СписокДокументов Цикл
		
		МенеджерДокумента = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяДокумента);
		
		Для Каждого ПолноеИмяРегистра Из Регистры Цикл
			ИмяРегистра = СтрРазделить(ПолноеИмяРегистра,".",Ложь)[1];
			МенеджерРегистра = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяРегистра);
			
			ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыВыборкиДанныхДляОбработки();
			ДополнительныеПараметры.ДополнительныеИсточникиДанных = МенеджерДокумента.ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра);
			
			ВыборкаПоРегистраторам = ОбновлениеИнформационнойБазы.ВыбратьРегистраторыРегистраДляОбработки(Очередь,
																										ПолноеИмяДокумента,
																										ПолноеИмяРегистра,
																										ДополнительныеПараметры);
			
			Пока ВыборкаПоРегистраторам.Следующий() Цикл
				
				НачатьТранзакцию();
				
				Попытка
					
					// Устанавливаем управляемую блокировку, чтобы провести ответственное чтение объекта
					Блокировка = Новый БлокировкаДанных;
					
					ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяДокумента);
					ЭлементБлокировки.УстановитьЗначение("Ссылка", ВыборкаПоРегистраторам.Регистратор);
					ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
					
					Блокировка.Заблокировать();
					
					НаборЗаписей = МенеджерРегистра.СоздатьНаборЗаписей();
					НаборЗаписей.Отбор.Регистратор.Установить(ВыборкаПоРегистраторам.Регистратор);
					
					//Выполним ответственное чтение реквизита "Проведен"
					РегистраторПроведен = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВыборкаПоРегистраторам.Регистратор, "Проведен");
					
					Если РегистраторПроведен Тогда
						ДопСвойства = Новый Структура;
						ИнтеграцияЕГАИС.ИнициализироватьДополнительныеСвойстваДляПроведения(ВыборкаПоРегистраторам.Регистратор, ДопСвойства);
						МенеджерДокумента.ИнициализироватьДанныеДокумента(ВыборкаПоРегистраторам.Регистратор, ДопСвойства, ИмяРегистра);
					
						НаборЗаписей.Загрузить(ДопСвойства.ТаблицыДляДвижений["Таблица" + ИмяРегистра]);
					КонецЕсли;
					
					ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
					
					ЗафиксироватьТранзакцию();
				Исключение
					
					ОтменитьТранзакцию();
					
					ТекстСообщения = НСтр("ru = 'Не удалось перезаписать движения в регистр %ИмяРегистра% по документу %Ссылка% по причине: %Причина%'");
					ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", ВыборкаПоРегистраторам.Регистратор);
					ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
					ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ИмяРегистра%", ПолноеИмяРегистра);
					
					ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
					Метаданные.НайтиПоПолномуИмени(ПолноеИмяДокумента), ВыборкаПоРегистраторам.Регистратор, ТекстСообщения);
					
				КонецПопытки;
			КонецЦикла;
			
			Если Не ЕстьЕщеРабота
				И ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Очередь, ПолноеИмяРегистра) Тогда
				ЕстьЕщеРабота = Истина;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ВсеСделано = Не ЕстьЕщеРабота;
	Возврат ВсеСделано;
	
КонецФункции

#КонецОбласти