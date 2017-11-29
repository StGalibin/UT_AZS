﻿
#Область СлужебныеПроцедурыИФункции

#Область ЗаписьДвиженийВРегистры

// Процедура формирования движений по регистру "Партии товаров организаций".
//
// Параметры:
//	ДокументОбъект - Текущий документ
//	Отказ - Булево - Признак отказа от проведения документа
//
Процедура ОтразитьПартииТоваровОрганизаций(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	Таблица= ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаПартииТоваровОрганизаций;
	
	Если Отказ ИЛИ Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	Движения.ПартииТоваровОрганизаций.Записывать = Истина;
	Движения.ПартииТоваровОрганизаций.Загрузить(Таблица);
	
КонецПроцедуры

// Процедура формирования движений по регистру "Партии товаров переданные на комиссию".
//
// Параметры:
//	ДокументОбъект - Текущий документ
//	Отказ - Булево - Признак отказа от проведения документа
//
Процедура ОтразитьПартииТоваровПереданныеНаКомиссию(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	Таблица= ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаПартииТоваровПереданныеНаКомиссию;
	
	Если Отказ ИЛИ Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	Движения.ПартииТоваровПереданныеНаКомиссию.Записывать = Истина;
	Движения.ПартииТоваровПереданныеНаКомиссию.Загрузить(Таблица);
	
КонецПроцедуры

// Процедура формирования движений по регистру "Партии расходов на себестоимость товаров".
//
// Параметры:
//	ДокументОбъект - Текущий документ
//	Отказ - Булево - Признак отказа от проведения документа
//
Процедура ОтразитьПартииРасходовНаСебестоимостьТоваров(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	Таблица= ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаПартииРасходовНаСебестоимостьТоваров;
	
	Если Отказ ИЛИ Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	Движения.ПартииРасходовНаСебестоимостьТоваров.Записывать = Истина;
	Движения.ПартииРасходовНаСебестоимостьТоваров.Загрузить(Таблица);
	
КонецПроцедуры

// Процедура формирует записи в регистре сведений "Задания к расчету себестоимости",
// если текущий документ изменяет записи в оперативных регистрах.
// Параметры:
//	Документ - Документ.Ссылка - Ссылка на документ-регистратор
//	ДополнительныеСвойства - Структура - Коллекция, содержащая в себе менеджер временных таблиц.
Процедура ОтразитьЗаданияКРасчетуСебестоимости(Документ, ДополнительныеСвойства) Экспорт
	
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда // задания устанавливаются только в главном узле.
		Возврат;
	КонецЕсли;
	
	КоллекцияКонтрольныхРегистров = КоллекцияКонтрольныхРегистров();
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	ВременныеТаблицы = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	ШаблонЗапроса = "
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Месяц        КАК Месяц,
	|	Таблица.Организация  КАК Организация,
	|	Таблица.Документ     КАК Документ,
	|	Таблица.ИзмененыДанныеДляПартионногоУчетаВерсии21 КАК ИзмененыДанныеДляПартионногоУчетаВерсии21
	|ИЗ
	|	&КоллекцияДанных КАК Таблица
	|";
		
	ТекстВложенногоЗапроса = "";
	ТекстУничтожитьВт = "; ";
		
	Для Каждого КонтрольныйРегистр Из КоллекцияКонтрольныхРегистров Цикл
		ДополнитьТекстЗапросаЗаданий(КонтрольныйРегистр, ВременныеТаблицы.Таблицы, ШаблонЗапроса, ТекстВложенногоЗапроса, ТекстУничтожитьВт)
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ТекстВложенногоЗапроса) Тогда // есть хотя бы один контрольный регистр.
		ТекстЗапроса = СтрЗаменить(ШаблонЗапроса, "&КоллекцияДанных", "(" + ТекстВложенногоЗапроса + ")")
			+ ТекстУничтожитьВт;
			
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.МенеджерВременныхТаблиц = ВременныеТаблицы;
		
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			Возврат; // нет данных к записи
		КонецЕсли;
		
		Выборка = Результат.Выбрать();
		НомерЗадания = Константы.НомерЗаданияКРасчетуСебестоимости.Получить();
		Пока Выборка.Следующий() Цикл
			РегистрыСведений.ЗаданияКРасчетуСебестоимости.СоздатьЗаписьРегистра(
				Выборка.Месяц,
				Выборка.Документ,
				Выборка.Организация,
				НомерЗадания,
				Выборка.ИзмененыДанныеДляПартионногоУчетаВерсии21);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеМетодыРегистраЗаданий

Функция КоллекцияКонтрольныхРегистров()
	
	Коллекция = Новый Массив();
	Коллекция.Добавить("ВыпускПродукцииЗаданияКРасчетуСебестоимости");
	Коллекция.Добавить("ВыручкаИСебестоимостьПродажЗаданияКРасчетуСебестоимости");
	Коллекция.Добавить("МатериалыИРаботыВПроизводствеЗаданияКРасчетуСебестоимости");
	Коллекция.Добавить("ПартииНезавершенногоПроизводстваЗаданияКРасчетуСебестоимости");
	Коллекция.Добавить("ПартииПроизводственныхЗатратЗаданияКРасчетуСебестоимости");
	Коллекция.Добавить("ПартииПрочихРасходовЗаданияКРасчетуСебестоимости");
	Коллекция.Добавить("ПартииРасходовНаСебестоимостьТоваровЗаданияКРасчетуСебестоимости");
	Коллекция.Добавить("ПартииТоваровОрганизацийЗаданияКРасчетуСебестоимости");
	Коллекция.Добавить("ПартииТоваровПереданныеНаКомиссиюЗаданияКРасчетуСебестоимости");
	Коллекция.Добавить("ПрочиеРасходыЗаданияКРасчетуСебестоимости");
	Коллекция.Добавить("ПрочиеРасходыНезавершенногоПроизводстваЗаданияКРасчетуСебестоимости");
	Коллекция.Добавить("СебестоимостьТоваровЗаданияКРасчетуСебестоимости");
	Коллекция.Добавить("ТоварыКОформлениюОтчетовКомитентуЗаданияКРасчетуСебестоимости");
	Коллекция.Добавить("ТоварыОрганизацийЗаданияКРасчетуСебестоимости");
	Коллекция.Добавить("ТоварыОрганизацийКПередачеЗаданияКРасчетуСебестоимости");
	Коллекция.Добавить("ТоварыПереданныеНаКомиссиюЗаданияКРасчетуСебестоимости");
	Коллекция.Добавить("ТрудозатратыНезавершенногоПроизводстваЗаданияКРасчетуСебестоимости");
	
	Возврат Коллекция;
КонецФункции

Процедура ДополнитьТекстЗапросаЗаданий(ИмяТаблицы, Таблицы, ШаблонЗапроса, ТекстЗапроса, ТекстУничтожитьВт)
	Если Таблицы.Найти(ИмяТаблицы) <> Неопределено Тогда
		Если ЗначениеЗаполнено(ТекстЗапроса) Тогда
			ТекстЗапроса = ТекстЗапроса + "
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|";
		КонецЕсли;
		ТекстЗапроса = ТекстЗапроса + СтрЗаменить(ШаблонЗапроса, "&КоллекцияДанных", ИмяТаблицы);
		ТекстУничтожитьВт = ТекстУничтожитьВт + "УНИЧТОЖИТЬ " + ИмяТаблицы + "; ";
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область Проверки

// Выполняет проверку возможности отключения партионного учета.
//
// Возвращаемое значение:
//	Строка - Текст предупреждения.
//
Функция ПартионныйУчетНельзяВыключать() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	1 КАК КодПричины
	|ИЗ
	|	Документ.РасчетСебестоимостиТоваров КАК Т
	|ГДЕ
	|	Т.МетодОценки = ЗНАЧЕНИЕ(Перечисление.МетодыОценкиСтоимостиТоваров.ФИФОСкользящаяОценка)
	|	И Т.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	2 КАК КодПричины
	|ИЗ
	|	РегистрСведений.УчетнаяПолитикаОрганизаций КАК РегУчетнаяПолитика
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.УчетныеПолитикиОрганизаций КАК СпрУчетнаяПолитика
	|		ПО РегУчетнаяПолитика.УчетнаяПолитика = СпрУчетнаяПолитика.Ссылка
	|ГДЕ
	|	СпрУчетнаяПолитика.МетодОценкиСтоимостиТоваров = ЗНАЧЕНИЕ(Перечисление.МетодыОценкиСтоимостиТоваров.ФИФОСкользящаяОценка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	3 КАК КодПричины
	|ИЗ
	|	РегистрСведений.УчетнаяПолитикаОрганизаций КАК РегУчетнаяПолитика
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.УчетныеПолитикиОрганизаций КАК СпрУчетнаяПолитика
	|		ПО РегУчетнаяПолитика.УчетнаяПолитика = СпрУчетнаяПолитика.Ссылка
	|ГДЕ
	|	СпрУчетнаяПолитика.ПрименяетсяУчетНДСПоФактическомуИспользованию
	|
	|УПОРЯДОЧИТЬ ПО
	|	КодПричины
	|";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ТекстПредупреждения = "";
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.КодПричины = 1 Тогда
			ТекстПредупреждения = ТекстПредупреждения + "
				|    - " + НСтр("ru='есть документы ""Расчет себестоимости товаров"" с методом оценки стоимости товаров ""ФИФО (скользящая оценка)""'");
		ИначеЕсли Выборка.КодПричины = 2 Тогда
			ТекстПредупреждения = ТекстПредупреждения + "
				|    - " + НСтр("ru='есть организации с методом оценки стоимости товаров ""ФИФО (скользящая оценка)""'");
		ИначеЕсли Выборка.КодПричины = 3 Тогда
			ТекстПредупреждения = ТекстПредупреждения + "
				|    - " + НСтр("ru='есть организации, ведущие учет НДС по фактическому использованию'");
		Иначе
			ВызватьИсключение НСтр("ru='Неизвестный код причины.'");
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда
		ТекстПредупреждения = НСтр("ru='Невозможно отключение партионного учета:'")
			+ ТекстПредупреждения;;
	КонецЕсли;
	
	Возврат ТекстПредупреждения;
	
КонецФункции

// Выполняет проверку возможности понижения версии партионного учета с 2.2 до 2.1.
//
// Возвращаемое значение:
//	Строка - Текст предупреждения.
//
Функция ПартионныйУчетВерсии22НельзяПонизитьДоВерсии21() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	1 КАК КодПричины
	|ИЗ
	|	РегистрНакопления.СебестоимостьТоваров КАК Т
	|ГДЕ
	|	Т.РасчетПартий
	|	ИЛИ Т.ТипЗаписи = ЗНАЧЕНИЕ(Перечисление.ТипыЗаписейПартий.ПереносДанных)
	|   ИЛИ Т.Партия <> НЕОПРЕДЕЛЕНО
	|   ИЛИ Т.АналитикаУчетаПартий <> ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаПартий.ПустаяСсылка)
	|   ИЛИ Т.АналитикаФинансовогоУчета <> НЕОПРЕДЕЛЕНО
	|   ИЛИ Т.ВидДеятельностиНДС <> ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка)
	|	ИЛИ Т.Трудозатраты <> 0
	|	ИЛИ Т.ПостатейныеПостоянныеСНДС <> 0
	|	ИЛИ Т.ПостатейныеПостоянныеБезНДС <> 0
	|	ИЛИ Т.ПостатейныеПеременныеСНДС <> 0
	|	ИЛИ Т.ПостатейныеПеременныеБезНДС <> 0
	|	ИЛИ Т.ДопРасходыРегл <> 0
	|	ИЛИ Т.ТрудозатратыРегл <> 0
	|	ИЛИ Т.ПостатейныеПостоянныеРегл <> 0
	|	ИЛИ Т.ПостатейныеПеременныеРегл <> 0
	|	ИЛИ Т.СтоимостьУпр <> 0
	|	ИЛИ Т.ДопРасходыУпр <> 0
	|	ИЛИ Т.ТрудозатратыУпр <> 0
	|	ИЛИ Т.ПостатейныеПостоянныеУпр <> 0
	|	ИЛИ Т.ПостатейныеПеременныеУпр <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	3 КАК КодПричины
	|ИЗ
	|	(ВЫБРАТЬ
	|		0 КАК ЧислоЗаписей
	|
	|	 ОБЪЕДИНИТЬ ВСЕ
	|
	|	 ВЫБРАТЬ ПЕРВЫЕ 1
	|		1 КАК ЧислоЗаписей
	|	 ИЗ
	|		РегистрНакопления.ПартииТоваровОрганизаций КАК Т
	|	) КАК Т
	|ИМЕЮЩИЕ
	|	СУММА(Т.ЧислоЗаписей) = 0
	|
	|
	|УПОРЯДОЧИТЬ ПО
	|	КодПричины
	|";
	
	ТекстПредупреждения = "";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.КодПричины = 1 Тогда
			ТекстПредупреждения = ТекстПредупреждения + "
				|    - " + НСтр("ru='есть движения по себестоимости товаров, сформированные партионным учетом версии 2.2'");
		ИначеЕсли Выборка.КодПричины = 3 Тогда
			ТекстПредупреждения = ТекстПредупреждения + "
				|    - " + НСтр("ru='в данной информационной базе партионный учет версии 2.1 не использовался'");
		Иначе
			ВызватьИсключение НСтр("ru='Неизвестный код причины.'");
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда
		ТекстПредупреждения = НСтр("ru='Невозможен возврат к партионному учету версии 2.1:'")
			+ ТекстПредупреждения;;
	КонецЕсли;
	
	Возврат ТекстПредупреждения;
	
КонецФункции

// Возвращает месяц первых движений по регистру себестоимости.
// Можно считать, что эта дата соответствует началу ведения учета в ИБ.
//
Функция ПериодПервыхДвиженийРегистраСебестоимость() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(Т.Период, МЕСЯЦ) КАК Период
	|ИЗ
	|	(ВЫБРАТЬ
	|		МИНИМУМ(Т.Период) КАК Период
	|	ИЗ
	|		РегистрНакопления.СебестоимостьТоваров КАК Т) КАК Т
	|ГДЕ
	|	Т.Период ЕСТЬ НЕ NULL ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Результат = Выборка.Период;
	Иначе
		Результат = Дата(1,1,1);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает месяц первых движений, сформированных в партионном учете версии 2.2
//
Функция ПериодПервыхДвиженийПартионныйУчетВерсии22() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДОБАВИТЬКДАТЕ(КОНЕЦПЕРИОДА(Т.Период, МЕСЯЦ), СЕКУНДА, 1) КАК Период
	|ИЗ
	|	(ВЫБРАТЬ
	|		МИНИМУМ(Т.Период) КАК Период
	|	ИЗ
	|		РегистрНакопления.СебестоимостьТоваров КАК Т
	|	ГДЕ
	|		(Т.РасчетПартий
	|		ИЛИ Т.ТипЗаписи = ЗНАЧЕНИЕ(Перечисление.ТипыЗаписейПартий.ПереносДанных)
	|		ИЛИ Т.Партия <> НЕОПРЕДЕЛЕНО
	|		ИЛИ Т.АналитикаУчетаПартий <> ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаПартий.ПустаяСсылка)
	|		ИЛИ Т.АналитикаФинансовогоУчета <> НЕОПРЕДЕЛЕНО
	|		ИЛИ Т.ВидДеятельностиНДС <> ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка)
	|		ИЛИ Т.Трудозатраты <> 0
	|		ИЛИ Т.ПостатейныеПостоянныеСНДС <> 0
	|		ИЛИ Т.ПостатейныеПостоянныеБезНДС <> 0
	|		ИЛИ Т.ПостатейныеПеременныеСНДС <> 0
	|		ИЛИ Т.ПостатейныеПеременныеБезНДС <> 0
	|		ИЛИ Т.ДопРасходыРегл <> 0
	|		ИЛИ Т.ТрудозатратыРегл <> 0
	|		ИЛИ Т.ПостатейныеПостоянныеРегл <> 0
	|		ИЛИ Т.ПостатейныеПеременныеРегл <> 0
	|		ИЛИ Т.СтоимостьУпр <> 0
	|		ИЛИ Т.ДопРасходыУпр <> 0
	|		ИЛИ Т.ТрудозатратыУпр <> 0
	|		ИЛИ Т.ПостатейныеПостоянныеУпр <> 0
	|		ИЛИ Т.ПостатейныеПеременныеУпр <> 0)) КАК Т
	|ГДЕ
	|	Т.Период ЕСТЬ НЕ NULL ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Результат = Выборка.Период;
	Иначе
		Результат = Дата(1,1,1);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ПересчетПрошлыхПериодов

// Создает задания к расчету себестоимости при изменении даты перехода на партионный учет версии 2.2
//
Процедура ЗапланироватьПересчетСебестоимостиВерсии22() Экспорт
	
	Если НЕ УниверсальныеМеханизмыПартийИСебестоимостиПовтИсп.ПартионныйУчетВерсии22() Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("ДатаПереходаНаПартионныйУчетВерсии22",
		НачалоМесяца(Константы.ДатаПереходаНаПартионныйУчетВерсии22.Получить()));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Т.Организация КАК Организация,
	|	ВЫБОР
	|		КОГДА НАЧАЛОПЕРИОДА(Т.Период, МЕСЯЦ) >= &ДатаПереходаНаПартионныйУчетВерсии22 И НЕ Т.ЕстьПереносДанных
	|			ТОГДА НАЧАЛОПЕРИОДА(Т.Период, МЕСЯЦ)
	|		ИНАЧЕ &ДатаПереходаНаПартионныйУчетВерсии22
	|	КОНЕЦ КАК Месяц
	|ПОМЕСТИТЬ ВТПересчетСебестоимости
	|ИЗ
	|	(ВЫБРАТЬ
	|		Т.Организация КАК Организация,
	|		МИНИМУМ(Т.Период) КАК Период,
	|		МАКСИМУМ(ВЫБОР
	|				КОГДА Т.ТипЗаписи = ЗНАЧЕНИЕ(Перечисление.ТипыЗаписейПартий.ПереносДанных)
	|					ТОГДА ИСТИНА
	|				ИНАЧЕ ЛОЖЬ
	|			КОНЕЦ) КАК ЕстьПереносДанных
	|	ИЗ
	|		РегистрНакопления.СебестоимостьТоваров КАК Т
	|	
	|	СГРУППИРОВАТЬ ПО
	|		Т.Организация) КАК Т
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация";
	
	СформироватьЗаданияКПересчетуСебестоимости(Запрос);
	
КонецПроцедуры

// Создает задания к расчету себестоимости при отключении партионного учета версии 2.2
//
Процедура ЗапланироватьПересчетСебестоимостиПриОтключенииПУВерсии22() Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартионныйУчет") Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СебестоимостьТоваров.Организация КАК Организация,
	|	МИНИМУМ(НАЧАЛОПЕРИОДА(СебестоимостьТоваров.Период, МЕСЯЦ)) КАК Месяц
	|ПОМЕСТИТЬ ВТПересчетСебестоимости
	|ИЗ
	|	РегистрНакопления.СебестоимостьТоваров КАК СебестоимостьТоваров
	|ГДЕ
	|	СебестоимостьТоваров.Активность
	|	И НЕ СебестоимостьТоваров.Регистратор ССЫЛКА Документ.КорректировкаРегистров
	|	И (СебестоимостьТоваров.Партия <> НЕОПРЕДЕЛЕНО
	|		ИЛИ СебестоимостьТоваров.АналитикаУчетаПартий <> ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаПартий.ПустаяСсылка)
	|		ИЛИ СебестоимостьТоваров.АналитикаФинансовогоУчета <> НЕОПРЕДЕЛЕНО
	|		ИЛИ СебестоимостьТоваров.ВидДеятельностиНДС <> ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка))
	|
	|СГРУППИРОВАТЬ ПО
	|	СебестоимостьТоваров.Организация
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация";
	
	СформироватьЗаданияКПересчетуСебестоимости(Запрос);
	
КонецПроцедуры

Процедура ЗапланироватьПересчетСебестоимостиПриИзмененииУправленческогоУчетаОрганизаций() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СебестоимостьТоваров.Организация КАК Организация,
	|	МИНИМУМ(НАЧАЛОПЕРИОДА(СебестоимостьТоваров.Период, МЕСЯЦ)) КАК Месяц
	|ПОМЕСТИТЬ ВТПересчетСебестоимости
	|ИЗ
	|	РегистрНакопления.СебестоимостьТоваров КАК СебестоимостьТоваров
	|		ЛЕВОЕ СОЕДИНЕНИЕ Константы КАК Константы
	|		ПО (ИСТИНА)
	|ГДЕ
	|	СебестоимостьТоваров.Период >= НАЧАЛОПЕРИОДА(Константы.ДатаНачалаВеденияУправленческогоУчетаОрганизаций, МЕСЯЦ)
	|	И ВЫБОР КОГДА Константы.ВестиУправленческийУчетОрганизаций
	|		ТОГДА СебестоимостьТоваров.Период >= НАЧАЛОПЕРИОДА(Константы.ДатаПереходаНаПартионныйУчетВерсии22, МЕСЯЦ)
	|		ИНАЧЕ ИСТИНА
	|	 КОНЕЦ
	|
	|СГРУППИРОВАТЬ ПО
	|	СебестоимостьТоваров.Организация
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация";
	
	СформироватьЗаданияКПересчетуСебестоимости(Запрос);
	
КонецПроцедуры

Процедура СформироватьЗаданияКПересчетуСебестоимости(Запрос)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос.Выполнить();
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Задания.Организация КАК Организация,
	|	МИНИМУМ(НАЧАЛОПЕРИОДА(Задания.Месяц, МЕСЯЦ)) КАК Месяц
	|ПОМЕСТИТЬ ВТЗаданияКРасчету
	|ИЗ
	|	РегистрСведений.ЗаданияКРасчетуСебестоимости КАК Задания
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПересчетСебестоимости КАК Пересчеты
	|		ПО Задания.Организация = Пересчеты.Организация
	|
	|СГРУППИРОВАТЬ ПО
	|	Задания.Организация
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Пересчеты.Организация,
	|	Пересчеты.Месяц
	|ИЗ
	|	ВТПересчетСебестоимости КАК Пересчеты
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТЗаданияКРасчету КАК Задания
	|		ПО Пересчеты.Организация = Задания.Организация
	|ГДЕ
	|	(Задания.Месяц ЕСТЬ NULL 
	|			ИЛИ Задания.Месяц > Пересчеты.Месяц)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	РегистрыСведений.ЗаданияКРасчетуСебестоимости.СоздатьЗаписиРегистраПоДаннымВыборки(Выборка);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
