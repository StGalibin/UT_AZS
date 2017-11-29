﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

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


#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Валюта КАК Валюта,
	|	ДанныеДокумента.Организация КАК Организация
	|ИЗ
	|	Документ.ВнесениеДенежныхСредствВКассуККМ КАК ДанныеДокумента
	|	
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Период", Реквизиты.Период);
	Запрос.УстановитьПараметр("Валюта", Реквизиты.Валюта);
	Запрос.УстановитьПараметр("Организация", Реквизиты.Организация);
	
КонецПроцедуры

Процедура УстановитьПараметрыЗапросаКоэффициентыВалют(Запрос)
	
	Если Запрос.Параметры.Свойство("КоэффициентПересчетаВВалютуУпр")
		И Запрос.Параметры.Свойство("КоэффициентПересчетаВВалютуРегл") Тогда
		Возврат;
	КонецЕсли;
	
	Коэффициенты = РаботаСКурсамивалютУТ.ПолучитьКоэффициентыПересчетаВалюты(Запрос.Параметры.Валюта,
																			Запрос.Параметры.Валюта,
																			Запрос.Параметры.Период);
	
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуУпр",  Коэффициенты.КоэффициентПересчетаВВалютуУПР);
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуРегл", Коэффициенты.КоэффициентПересчетаВВалютуРегл);
	
КонецПроцедуры

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаДенежныеСредстваВКассахККМ(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаДенежныеСредстваВПути(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаДвиженияДенежныхСредств(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаСуммыДокументовВВалютеРегл(Запрос, ТекстыЗапроса, Регистры);
	
	
	ПроведениеСерверУТ.ИнициализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаДенежныеСредстваВКассахККМ(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДенежныеСредстваВКассахККМ";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	УстановитьПараметрыЗапросаКоэффициентыВалют(Запрос);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата                   КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ДанныеДокумента.Организация            КАК Организация,
	|	ДанныеДокумента.КассаККМ               КАК КассаККМ,
	|	ДанныеДокумента.СуммаДокумента         КАК Сумма,
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаДокумента * &КоэффициентПересчетаВВалютуРегл КАК ЧИСЛО(15, 2)) КАК СуммаРегл,
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаДокумента * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(15, 2)) КАК СуммаУпр,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВнесениеДенежныхСредствВКассуККМ) КАК ХозяйственнаяОперация,
	|	ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ВыдачаДенежныхСредствВДругуюКассу) КАК СтатьяДвиженияДенежныхСредств
	|	
	|ИЗ
	|	Документ.ВнесениеДенежныхСредствВКассуККМ КАК ДанныеДокумента
	|	
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДенежныеСредстваВПути(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДенежныеСредстваВПути";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;

	УстановитьПараметрыЗапросаКоэффициентыВалют(Запрос);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)                                      КАК ВидДвижения,
	|	ДанныеДокумента.Дата                                                        КАК Период,
	|	
	|	ДанныеДокумента.Организация                                                 КАК Организация,
	|	ДанныеДокумента.КассаККМ                                                    КАК Получатель,
	|	НЕОПРЕДЕЛЕНО                                                                КАК Отправитель,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ПеремещениеВДругуюКассу) КАК ВидПереводаДенежныхСредств,
	|	НЕОПРЕДЕЛЕНО                                                                КАК Контрагент,
	|	ДанныеДокумента.Валюта                                                      КАК Валюта,
	|	
	|	ДанныеДокумента.СуммаДокумента                                              КАК Сумма,
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаДокумента * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(15, 2))   КАК СуммаУпр,
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаДокумента * &КоэффициентПересчетаВВалютуРегл КАК ЧИСЛО(15, 2))  КАК СуммаРегл,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВнесениеДенежныхСредствВКассуККМ) КАК ХозяйственнаяОперация,
	|	ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ВыдачаДенежныхСредствВДругуюКассу) КАК СтатьяДвиженияДенежныхСредств
	|	
	|ИЗ
	|	Документ.ВнесениеДенежныхСредствВКассуККМ КАК ДанныеДокумента
	|	
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И ДанныеДокумента.СуммаДокумента <> 0
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДвиженияДенежныхСредств(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДвиженияДенежныхСредств";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 

	УстановитьПараметрыЗапросаКоэффициентыВалют(Запрос);
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	Значение(Перечисление.ХозяйственныеОперации.ВнесениеДенежныхСредствВКассуККМ) КАК ХозяйственнаяОперация,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.КассаККМ.Подразделение КАК Подразделение,
	|
	|	ДанныеДокумента.Касса КАК ДенежныеСредства,
	|	Значение(Перечисление.ТипыДенежныхСредств.ДенежныеСредстваВПути) КАК ТипДенежныхСредств,
	|	ЗНАЧЕНИЕ(Справочник.СтатьиДвиженияДенежныхСредств.ВыдачаДенежныхСредствВДругуюКассу) КАК СтатьяДвиженияДенежныхСредств,
	|	ДанныеДокумента.Валюта КАК Валюта,
	|	ДанныеДокумента.Валюта КАК КорВалюта,
	|
	|	ДанныеДокумента.КассаККМ КАК КорДенежныеСредства,
	|	Значение(Перечисление.ТипыДенежныхСредств.Наличные) КАК КорТипДенежныхСредств,
	|
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаДокумента * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(15, 2)) КАК Сумма,
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаДокумента * &КоэффициентПересчетаВВалютуРегл КАК ЧИСЛО(15, 2)) КАК СуммаРегл,
	|	ДанныеДокумента.СуммаДокумента КАК СуммаВВалюте,
	|	ДанныеДокумента.СуммаДокумента КАК СуммаВКорВалюте,
	|
	|	ДанныеДокумента.Касса КАК ИсточникГФУДенежныхСредств,
	|	НЕОПРЕДЕЛЕНО КАК ИсточникКорГФУДенежныхСредств
	|ИЗ
	|	Документ.ВнесениеДенежныхСредствВКассуККМ КАК ДанныеДокумента
	|	
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;

КонецФункции

Функция ТекстЗапросаТаблицаСуммыДокументовВВалютеРегл(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "СуммыДокументовВВалютеРегл";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	УстановитьПараметрыЗапросаКоэффициентыВалют(Запрос);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	0 КАК НомерСтроки,
	|	&Период КАК Период,
	|	&Валюта КАК Валюта,
	|	"""" КАК ИдентификаторСтроки,
	|	НЕОПРЕДЕЛЕНО КАК СтавкаНДС,
	|	Документ.СуммаДокумента КАК СуммаБезНДС,
	|	0 КАК СуммаНДС,
	|	Документ.СуммаДокумента * &КоэффициентПересчетаВВалютуРегл КАК СуммаБезНДСРегл,
	|	0 КАК СуммаНДСРегл,
	|	НЕОПРЕДЕЛЕНО КАК ТипРасчетов
	|ИЗ
	|	Документ.ВнесениеДенежныхСредствВКассуККМ КАК Документ
	|ГДЕ
	|	Документ.Ссылка = &Ссылка
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции


// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецОбласти

#КонецЕсли
