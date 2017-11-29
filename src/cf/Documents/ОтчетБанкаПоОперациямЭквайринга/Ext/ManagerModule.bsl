﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	СозданиеНаОснованииПереопределяемый.ДобавитьКомандуСоздатьНаОснованииБизнесПроцессЗадание(КомандыСозданияНаОсновании);
	
КонецПроцедуры

// Добавляет команду создания документа "Отчет банка по эквайрингу".
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Добавление", Метаданные.Документы.ОтчетБанкаПоОперациямЭквайринга) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ОтчетБанкаПоОперациямЭквайринга.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ОтчетБанкаПоОперациямЭквайринга);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьОплатуПлатежнымиКартами";
	

		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);
	
	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуДвиженияДокумента(КомандыОтчетов);
	
КонецПроцедуры


// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	// Создание запроса инициализации движений и заполенение его параметров
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);

	// Текст запроса, формирующего таблицы движений
	ТекстыЗапроса = Новый СписокЗначений;
	
	ТекстЗапросаРасчетыПоЭквайрингу(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаДенежныеСредстваВПути(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаПрочиеРасходы(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаПрочиеАктивыПассивы(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаДвиженияДенежныеСредстваДоходыРасходы(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаСуммыДокументовВВалютеРегл(Запрос, ТекстыЗапроса, Регистры);
	
	// Выполение запроса и выгрузка полученных таблиц для формирования движений
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Валюта КАК Валюта,
	|	ДанныеДокумента.Организация КАК Организация
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Период", Реквизиты.Период);
	Запрос.УстановитьПараметр("Валюта", Реквизиты.Валюта);
	Запрос.УстановитьПараметр("Организация", Реквизиты.Организация);
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", Константы.ВалютаРегламентированногоУчета.Получить());
	Запрос.УстановитьПараметр("ВалютаУправленческогоУчета", Константы.ВалютаУправленческогоУчета.Получить());
	УниверсальныеМеханизмыПартийИСебестоимости.ЗаполнитьПараметрыИнициализации(Запрос, Реквизиты);
	
КонецПроцедуры

Процедура УстановитьПараметрыЗапросаКоэффициентыПересчетаВВалютыРеглИУпр(Запрос)
	
	Если Запрос.Параметры.Свойство("КоэффициентПересчетаВВалютуРегл")
		И Запрос.Параметры.Свойство("КоэффициентПересчетаВВалютуУпр") Тогда
		Возврат;
	КонецЕсли;
	
	Коэффициенты = РаботаСКурсамиВалютУТ.ПолучитьКоэффициентыПересчетаВалюты(
		Запрос.Параметры.Валюта,
		Неопределено,
		Запрос.Параметры.Период);
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуРегл", Коэффициенты.КоэффициентПересчетаВВалютуРегл);
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуУпр", Коэффициенты.КоэффициентПересчетаВВалютуУПР);
	
КонецПроцедуры

Функция ТекстЗапросаРасчетыПоЭквайрингу(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РасчетыПоЭквайрингу";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Платежи.НомерСтроки КАК НомерСтроки,
	|	&Период КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредствПоЭквайрингу.ПоступлениеПоПлатежнойКарте) КАК ТипДенежныхСредств,
	|
	|	&Организация КАК Организация,
	|	&Валюта КАК Валюта,
	|	Платежи.ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
	|	Платежи.КодАвторизации КАК КодАвторизации,
	|	Платежи.НомерПлатежнойКарты КАК НомерПлатежнойКарты,
	|	Платежи.ДатаПлатежа КАК ДатаПлатежа,
	|	Платежи.Сумма КАК Сумма,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.КомиссияПоЭквайрингу) КАК ХозяйственнаяОперация,
	|	ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ОплатаПоставщику) КАК СтатьяДвиженияДенежныхСредств
	|	
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга.Покупки КАК Платежи
	|	
	|ГДЕ
	|	Платежи.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Платежи.НомерСтроки КАК НомерСтроки,
	|	&Период КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредствПоЭквайрингу.СписаниеПоПлатежнойКарте) КАК ТипДенежныхСредств,
	|
	|	&Организация КАК Организация,
	|	&Валюта КАК Валюта,
	|	Платежи.ЭквайринговыйТерминал КАК ЭквайринговыйТерминал,
	|	Платежи.КодАвторизации КАК КодАвторизации,
	|	Платежи.НомерПлатежнойКарты КАК НомерПлатежнойКарты,
	|	Платежи.ДатаПлатежа КАК ДатаПлатежа,
	|	Платежи.Сумма КАК Сумма,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.КомиссияПоЭквайрингу) КАК ХозяйственнаяОперация,
	|	ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ОплатаПоставщику) КАК СтатьяДвиженияДенежныхСредств
	|	
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга.Возвраты КАК Платежи
	|	
	|ГДЕ
	|	Платежи.Ссылка = &Ссылка
	|	
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаДенежныеСредстваВПути(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДенежныеСредстваВПути";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	УстановитьПараметрыЗапросаКоэффициентыПересчетаВВалютыРеглИУпр(Запрос);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)                                               КАК ВидДвижения,
	|	ДанныеДокумента.Дата                                                                 КАК Период,
	|	
	|	ДанныеДокумента.Организация                                                          КАК Организация,
	|	ДанныеДокумента.БанковскийСчет                                                       КАК Получатель,
	|	НЕОПРЕДЕЛЕНО                                                                         КАК Отправитель,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ПоступлениеОтБанкаПоЭквайрингу)   КАК ВидПереводаДенежныхСредств,
	|	ДанныеДокумента.Эквайер                                                              КАК Контрагент,
	|	ДанныеДокумента.Валюта                                                               КАК Валюта,
	|	
	|	ДанныеДокумента.СуммаКомиссии                                                                КАК Сумма,
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаКомиссии * &КоэффициентПересчетаВВалютуУпр КАК Число(15, 2))   КАК СуммаУпр,
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаКомиссии * &КоэффициентПересчетаВВалютуРегл  КАК Число(15, 2)) КАК СуммаРегл,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.КомиссияПоЭквайрингу)                    КАК ХозяйственнаяОперация,
	|	ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ОплатаПоставщику)                  КАК СтатьяДвиженияДенежныхСредств
	|	
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга КАК ДанныеДокумента
	|	
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И ДанныеДокумента.СуммаКомиссии <> 0";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаВтИсходныеПрочиеРасходы(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтИсходныеПрочиеРасходы";
	
	УстановитьПараметрыЗапросаКоэффициентыПересчетаВВалютыРеглИУпр(Запрос);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.БанковскийСчет.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ДанныеДокумента.СтатьяРасходов КАК СтатьяРасходов,
	|	ДанныеДокумента.АналитикаРасходов КАК АналитикаРасходов,
	|	ДанныеДокумента.Подразделение КАК Подразделение,
	|	НЕОПРЕДЕЛЕНО КАК ВидДеятельностиНДС,
	|	
	|	// Рассчитаем сумму в валюте управленческого учета.
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаКомиссии * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(15,2)) КАК СуммаСНДС,
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаКомиссии * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(15,2)) КАК СуммаБезНДС,
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаКомиссии * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(15,2)) КАК СуммаБезНДСУпр,
	|
	|	ЕСТЬNULL(СуммыДокументовВВалютеРегл.СуммаБезНДСРегл, ДанныеДокумента.СуммаКомиссии) КАК СуммаСНДСРегл,
	|	ЕСТЬNULL(СуммыДокументовВВалютеРегл.СуммаБезНДСРегл, ДанныеДокумента.СуммаКомиссии) КАК СуммаБезНДСРегл,
	|	0 КАК ПостояннаяРазница,
	|	0 КАК ВременнаяРазница,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ПрочиеРасходы) КАК ХозяйственнаяОперация,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаНоменклатуры
	|
	|ПОМЕСТИТЬ ВтИсходныеПрочиеРасходы
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга КАК ДанныеДокумента
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СуммыДокументовВВалютеРегл КАК СуммыДокументовВВалютеРегл
	|		ПО СуммыДокументовВВалютеРегл.Регистратор = ДанныеДокумента.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И ДанныеДокумента.СуммаКомиссии <> 0
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаВтПрочиеРасходы(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтПрочиеРасходы";
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтИсходныеПрочиеРасходы", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтИсходныеПрочиеРасходы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПрочиеРасходы.ТекстЗапросаТаблицаВтПрочиеРасходы();
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаПрочиеРасходы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПрочиеРасходы";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтПрочиеРасходы", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтПрочиеРасходы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПрочиеРасходы.ТекстЗапросаТаблицаПрочиеРасходы();
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДвиженияДенежныеСредстваДоходыРасходы(Запрос, ТекстыЗапроса, Регистры)

	ИмяРегистра = "ДвиженияДенежныеСредстваДоходыРасходы";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	УстановитьПараметрыЗапросаКоэффициентыПересчетаВВалютыРеглИУпр(Запрос);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	&Период КАК Период,
	|	Значение(Перечисление.ХозяйственныеОперации.КомиссияПоЭквайрингу) КАК ХозяйственнаяОперация,
	|	ДанныеПлатежногоДокумента.Организация КАК Организация,
	|	ДанныеПлатежногоДокумента.БанковскийСчет.Подразделение КАК Подразделение,
	|	ДанныеПлатежногоДокумента.БанковскийСчет.НаправлениеДеятельности КАК НаправлениеДеятельностиДС,
	|	ДанныеПлатежногоДокумента.Подразделение КАК ПодразделениеДоходовРасходов,
	|
	|	ДанныеПлатежногоДокумента.Эквайер КАК ДенежныеСредства,
	|	Значение(Перечисление.ТипыДенежныхСредств.ДенежныеСредстваУЭквайера) КАК ТипДенежныхСредств,
	|	ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ОплатаПоставщику) КАК СтатьяДвиженияДенежныхСредств,
	|	ДанныеПлатежногоДокумента.Ссылка.Валюта КАК Валюта,
	|
	|	ДанныеПлатежногоДокумента.БанковскийСчет.НаправлениеДеятельности КАК НаправлениеДеятельностиСтатьи,
	|	ДанныеПлатежногоДокумента.СтатьяРасходов КАК СтатьяДоходовРасходов,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаДоходов,
	|	ДанныеПлатежногоДокумента.АналитикаРасходов КАК АналитикаРасходов,
	|
	|	ВЫРАЗИТЬ(ДанныеПлатежногоДокумента.СуммаКомиссии * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(15, 2)) КАК Сумма,
	|	ВЫРАЗИТЬ(ДанныеПлатежногоДокумента.СуммаКомиссии * &КоэффициентПересчетаВВалютуРегл КАК ЧИСЛО(15, 2)) КАК СуммаРегл,
	|	ДанныеПлатежногоДокумента.СуммаКомиссии КАК СуммаВВалюте,
	|
	|	НЕОПРЕДЕЛЕНО КАК ИсточникГФУДенежныхСредств,
	|	ДанныеПлатежногоДокумента.СтатьяРасходов КАК ИсточникГФУДоходовРасходов
	|
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга КАК ДанныеПлатежногоДокумента
	|
	|ГДЕ
	|	ДанныеПлатежногоДокумента.Ссылка = &Ссылка
	|	И ДанныеПлатежногоДокумента.СуммаКомиссии <> 0";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);

	Возврат ТекстЗапроса;

КонецФункции

Функция ТекстЗапросаСуммыДокументовВВалютеРегл(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "СуммыДокументовВВалютеРегл";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	УстановитьПараметрыЗапросаКоэффициентыПересчетаВВалютыРеглИУпр(Запрос);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	"""" КАК ИдентификаторСтроки,
	|	&Период КАК Период,
	|	&Валюта КАК Валюта,
	|	НЕОПРЕДЕЛЕНО КАК СтавкаНДС,
	|	ДанныеДокумента.СуммаКомиссии КАК СуммаБезНДС,
	|	0 КАК СуммаНДС,
	|	ВЫБОР КОГДА &Валюта = &ВалютаРегламентированногоУчета
	|		ТОГДА ДанныеДокумента.СуммаКомиссии
	|		ИНАЧЕ ДанныеДокумента.СуммаКомиссии * &КоэффициентПересчетаВВалютуРегл
	|	КОНЕЦ КАК СуммаБезНДСРегл,
	|	0 КАК СуммаНДСРегл,
	|	ВЫБОР КОГДА &Валюта = &ВалютаУправленческогоУчета
	|		ТОГДА ДанныеДокумента.СуммаКомиссии
	|		ИНАЧЕ ДанныеДокумента.СуммаКомиссии * &КоэффициентПересчетаВВалютуУпр
	|	КОНЕЦ КАК СуммаБезНДСУпр,
	|	0 КАК СуммаНДСУпр,
	|	НЕОПРЕДЕЛЕНО КАК ТипРасчетов
	|
	|ИЗ
	|	Документ.ОтчетБанкаПоОперациямЭквайринга КАК ДанныеДокумента
	|
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаПрочиеАктивыПассивы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПрочиеАктивыПассивы";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если Не ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтПрочиеРасходы", ТекстыЗапроса) Тогда
		ТекстЗапросаТаблицаВтПрочиеРасходы(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса = РегистрыНакопления.ПрочиеАктивыПассивы.ТекстЗапросаТаблицаПрочиеАктивыПассивы(Ложь);
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции


#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецОбласти

#КонецЕсли
