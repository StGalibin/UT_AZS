﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Для товаров и складов из временной таблицы получает информацию о свободном для продажи количестве, суммарно по всем складам.
//
// Параметры:
//  ИмяТаблицыТовары - Строка - Имя временной таблицы товаров.
//
// Возвращаемое значение:
//  Строка - Текст запроса временной таблицы "ВтСвободноДляПродажи".
//
Функция ВременнаяТаблицаСвободноДляПродажиСуммарноПоСкладам(ИмяТаблицыТовары) Экспорт
	
	ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Набор.Номенклатура   КАК Номенклатура,
		|	Набор.Характеристика КАК Характеристика,
		|	СУММА(Набор.Количество) КАК Количество
		|ПОМЕСТИТЬ ВтСвободноДляПродажи
		|ИЗ(
		|	ВЫБРАТЬ
		|		СвободныеОстатки.Номенклатура   КАК Номенклатура,
		|		СвободныеОстатки.Характеристика КАК Характеристика,
		|		СвободныеОстатки.Склад          КАК Склад,
		|	
		|		СвободныеОстатки.ВНаличииОстаток
		|			- СвободныеОстатки.ВРезервеСоСкладаОстаток
		|			- СвободныеОстатки.ВРезервеПодЗаказОстаток КАК Количество
		|		
		|	ИЗ
		|		РегистрНакопления.СвободныеОстатки.Остатки(,
		|			(Номенклатура, Характеристика, Склад) В(
		|				ВЫБРАТЬ
		|					ТоварыКорзины.Номенклатура   КАК Номенклатура,
		|					ТоварыКорзины.Характеристика КАК Характеристика,
		|					ТоварыКорзины.Склад          КАК Склад
		|				ИЗ
		|					ВтТовары КАК ТоварыКорзины)) КАК СвободныеОстатки
		|		
		|	ОБЪЕДИНИТЬ ВСЕ
		|		
		|	ВЫБРАТЬ
		|		ТоварыКорзины.Номенклатура   КАК Номенклатура,
		|		ТоварыКорзины.Характеристика КАК Характеристика,
		|		ТоварыКорзины.Склад          КАК Склад,
		|		
		|		ОстаткиПланируемыхПоступлений.Количество КАК Количество
		|		
		|	ИЗ
		|		ВтТовары КАК ТоварыКорзины
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДоступныеОстаткиПланируемыхПоступлений КАК ОстаткиПланируемыхПоступлений
		|			ПО ОстаткиПланируемыхПоступлений.Номенклатура   = ТоварыКорзины.Номенклатура
		|			 И ОстаткиПланируемыхПоступлений.Характеристика = ТоварыКорзины.Характеристика
		|			 И ОстаткиПланируемыхПоступлений.Склад          = ТоварыКорзины.Склад
		|	ГДЕ
		|		ОстаткиПланируемыхПоступлений.ДатаДоступности = ДАТАВРЕМЯ(1, 1, 1) И ОстаткиПланируемыхПоступлений.Количество < 0) КАК Набор
		|СГРУППИРОВАТЬ ПО
		|	Набор.Номенклатура, Набор.Характеристика
		|;
		|
		|////////////////////////////////////////////////
		|";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ВтТовары", ИмяТаблицыТовары);
	Возврат ТекстЗапроса;
	
КонецФункции

// Для товаров и складов из временной таблицы получает необходимые временные таблицы для расчета ближайшей доступности товара на складе.
//
// Параметры:
//  ИмяТаблицыТовары - Строка - Имя временной таблицы товаров.
//
// Возвращаемое значение:
//  Строка - Текст запроса временных таблиц "ВтБлижайшиеДатыДоступности", "ВтДоступныеОстаткиПоДатам".
//
Функция ВременныеТаблицыДляРасчетаДоступныхОстатков(ИмяТаблицыТовары) Экспорт
	
	ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Набор.Номенклатура   КАК Номенклатура,
		|	Набор.Характеристика КАК Характеристика,
		|	Набор.Склад          КАК Склад,
		|	
		|	Набор.Период            КАК Период,
		|	СУММА(Набор.Количество) КАК Количество
		|ПОМЕСТИТЬ ВтДоступныеОстаткиПоДатам
		|ИЗ(
		|	ВЫБРАТЬ
		|		СвободныеОстатки.Номенклатура   КАК Номенклатура,
		|		СвободныеОстатки.Характеристика КАК Характеристика,
		|		СвободныеОстатки.Склад          КАК Склад,
		|	
		|		&НачалоТекущегоДня              КАК Период,
		|		СвободныеОстатки.ВНаличииОстаток
		|			- СвободныеОстатки.ВРезервеСоСкладаОстаток
		|			- СвободныеОстатки.ВРезервеПодЗаказОстаток КАК Количество
		|		
		|	ИЗ
		|		РегистрНакопления.СвободныеОстатки.Остатки(,
		|			(Номенклатура, Характеристика, Склад) В(
		|				ВЫБРАТЬ
		|					ТоварыКорзины.Номенклатура   КАК Номенклатура,
		|					ТоварыКорзины.Характеристика КАК Характеристика,
		|					ТоварыКорзины.Склад          КАК Склад
		|				ИЗ
		|					ВтТовары КАК ТоварыКорзины)) КАК СвободныеОстатки
		|		
		|	ОБЪЕДИНИТЬ ВСЕ
		|		
		|	ВЫБРАТЬ
		|		ТоварыКорзины.Номенклатура   КАК Номенклатура,
		|		ТоварыКорзины.Характеристика КАК Характеристика,
		|		ТоварыКорзины.Склад          КАК Склад,
		|		
		|		ВЫБОР КОГДА ОстаткиПланируемыхПоступлений.ДатаДоступности = ДАТАВРЕМЯ(1, 1, 1) ТОГДА
		|					&НачалоТекущегоДня
		|				ИНАЧЕ
		|					ОстаткиПланируемыхПоступлений.ДатаДоступности
		|			КОНЕЦ                                КАК Период,
		|		ОстаткиПланируемыхПоступлений.Количество КАК Количество
		|		
		|	ИЗ
		|		ВтТовары КАК ТоварыКорзины
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДоступныеОстаткиПланируемыхПоступлений КАК ОстаткиПланируемыхПоступлений
		|			ПО ОстаткиПланируемыхПоступлений.Номенклатура   = ТоварыКорзины.Номенклатура
		|			 И ОстаткиПланируемыхПоступлений.Характеристика = ТоварыКорзины.Характеристика
		|			 И ОстаткиПланируемыхПоступлений.Склад          = ТоварыКорзины.Склад
		|	ГДЕ
		|		ОстаткиПланируемыхПоступлений.ДатаДоступности = ДАТАВРЕМЯ(1, 1, 1) И ОстаткиПланируемыхПоступлений.Количество < 0
		|		ИЛИ ОстаткиПланируемыхПоступлений.ДатаДоступности > &НачалоТекущегоДня) КАК Набор
		|СГРУППИРОВАТЬ ПО
		|	Набор.Номенклатура, Набор.Характеристика, Набор.Склад, Набор.Период
		|ИМЕЮЩИЕ
		|	СУММА(Набор.Количество) > 0
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура, Характеристика, Склад
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДоступныеОстаткиПоДатам.Номенклатура   КАК Номенклатура,
		|	ДоступныеОстаткиПоДатам.Характеристика КАК Характеристика,
		|	ДоступныеОстаткиПоДатам.Склад          КАК Склад,
		|	
		|	МИНИМУМ(ДоступныеОстаткиПоДатам.Период) КАК Дата
		|ПОМЕСТИТЬ ВтБлижайшиеДатыДоступности
		|ИЗ
		|	ВтДоступныеОстаткиПоДатам КАК ДоступныеОстаткиПоДатам
		|		
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаКонтроляОбеспечения КАК НастройкаХарактеристика
		|		ПО ДоступныеОстаткиПоДатам.Склад          = НастройкаХарактеристика.Склад
		|		 И ДоступныеОстаткиПоДатам.Номенклатура   = НастройкаХарактеристика.Номенклатура
		|		 И ДоступныеОстаткиПоДатам.Характеристика = НастройкаХарактеристика.Характеристика
		|		
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаКонтроляОбеспечения КАК НастройкаНоменклатура
		|		ПО ДоступныеОстаткиПоДатам.Склад        = НастройкаНоменклатура.Склад
		|		 И ДоступныеОстаткиПоДатам.Номенклатура = НастройкаНоменклатура.Номенклатура
		|		 И НастройкаНоменклатура.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
		|		 И НастройкаХарактеристика.Склад ЕСТЬ NULL
		|		
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаКонтроляОбеспечения КАК НастройкаСклад
		|		ПО ДоступныеОстаткиПоДатам.Склад = НастройкаСклад.Склад
		|		 И НастройкаСклад.Номенклатура   = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		|		 И НастройкаСклад.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
		|		 И НастройкаХарактеристика.Склад ЕСТЬ NULL
		|		 И НастройкаНоменклатура.Склад ЕСТЬ NULL
		|	
		|ГДЕ
		|	ЕСТЬNULL(НастройкаХарактеристика.Контролировать, ЕСТЬNULL(НастройкаНоменклатура.Контролировать, НастройкаСклад.Контролировать))
		|СГРУППИРОВАТЬ ПО
		|	ДоступныеОстаткиПоДатам.Номенклатура, ДоступныеОстаткиПоДатам.Характеристика, ДоступныеОстаткиПоДатам.Склад
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура, Характеристика, Склад
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|";
		
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ВтТовары", ИмяТаблицыТовары);
	Возврат ТекстЗапроса;
	
КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	ИсточникиКоманд = Новый Структура;
	ИсточникиКоманд.Вставить("СписокЗаказов", "Документ.ЗаказКлиента");
	ИсточникиКоманд.Вставить("СчетаНаОплату", "Документ.СчетНаОплатуКлиенту");
	ИсточникиКоманд.Вставить("ДокументыРеализации", "Документ.РеализацияТоваровУслуг");
	ИсточникиКоманд.Вставить("АктыВыполненныхРабот", "Документ.АктВыполненныхРабот");
	ИсточникиКоманд.Вставить("Планы", "Документ.ПланПродаж");
	ИсточникиКоманд.Вставить("СписокОтчетовКомиссионера", "Документ.ОтчетКомиссионера");
	ИсточникиКоманд.Вставить("СписокЗаявокНаВозврат", "Документ.ЗаявкаНаВозвратТоваровОтКлиента");
	ИсточникиКоманд.Вставить("СписокПретензий", "Справочник.ПретензииКлиентов");
	ИсточникиКоманд.Вставить("МоиСоглашения", "Справочник.СоглашенияСКлиентами");
	ИсточникиКоманд.Вставить("АктыПриемки", "Документ.АктОРасхожденияхПослеОтгрузки");
	
	Для Каждого ИсточникКоманд Из ИсточникиКоманд Цикл
		КомандыПечатиИсточника = КомандыПечатиОбъекта(ИсточникКоманд.Значение);
		КомандыПечатиИсточника.ЗаполнитьЗначения(ИсточникКоманд.Ключ, "СписокФорм");
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(КомандыПечатиИсточника, КомандыПечати);
	КонецЦикла;
	
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
	
	КомандаОтчет = ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСостояниеВыполненияЗаказКлиента(КомандыОтчетов);
	Если КомандаОтчет <> Неопределено Тогда
		КомандаОтчет.ВидимостьВФормах = "СписокЗаказов";
	КонецЕсли;
	
	КомандаОтчет = ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСостояниеВыполненияЗаявокНаВозврат(КомандыОтчетов);
	Если КомандаОтчет <> Неопределено Тогда
		КомандаОтчет.ВидимостьВФормах = "СписокЗаявокНаВозврат";
	КонецЕсли;
	
	КомандаОтчет = ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСостояниеОбеспеченияСпискаЗаказовКлиента(КомандыОтчетов);
	Если КомандаОтчет <> Неопределено Тогда
		КомандаОтчет.ВидимостьВФормах = "СписокЗаказов,СписокЗаявокНаВозврат";
	КонецЕсли;
	
	КомандаОтчет = ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСостояниеВыполненияРеализацииАкта(КомандыОтчетов);
	Если КомандаОтчет <> Неопределено Тогда
		КомандаОтчет.ВидимостьВФормах = "АктыВыполненныхРабот,ДокументыРеализации";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КомандыПечатиОбъекта(ИмяОбъекта)
	КоллекцияКомандПечати = УправлениеПечатью.СоздатьКоллекциюКомандПечати();
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ИмяОбъекта);
	МенеджерОбъекта.ДобавитьКомандыПечати(КоллекцияКомандПечати);
	Для Каждого КомандаПечати Из КоллекцияКомандПечати Цикл
		Если ПустаяСтрока(КомандаПечати.МенеджерПечати) Тогда
			КомандаПечати.МенеджерПечати = ИмяОбъекта;
		КонецЕсли;
	КонецЦикла;
	Возврат КоллекцияКомандПечати;
КонецФункции

#Область СозданиеНаОсновании

// Определяет список команд создания на основании.
//
// Параметры:
//   КомандыСозданияНаОсновании - ТаблицаЗначений - Таблица с командами создания на основании. Для изменения.
//       См. описание 1 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании().
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьАктыРасхожденийПослеОтгрузкиПоРеализациям") Тогда
		КомандаСоздания = Документы.АктОРасхожденияхПослеОтгрузки.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
		Если КомандаСоздания <> Неопределено Тогда
			КомандаСоздания.Представление = НСтр("ru = 'Акт приемки'");
		КонецЕсли;
	КонецЕсли;
	
	Документы.ЗаявкаНаВозвратТоваровОтКлиента.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
	Справочники.ПретензииКлиентов.ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
