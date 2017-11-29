﻿///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ИНТЕРАКТИВНОЙ РАБОТЫ С МНОГООБОРОТНОЙ ТАРОЙ

#Область ПрограммныйИнтерфейс

// Открывает форму подбора многооборотной тары в документ
//
// Параметры:
// Форма - УправляемаяФорма - Форма, из которой подбирается многооборотная тара
// ИмяТаблицы - Строка - Имя таблицы с товарами и тарой документа
// ИменаКолонок - Строка - Имена колонок таблицы с товарами и тарой документа, разделенные запятыми
//
// Возвращаемое значение:
// Булево, Истина, если многооборотная тара подобрана
//
Процедура ПодобратьМногооборотнуюТару(Знач Форма,
	                                  Знач ИмяТаблицы,
	                                  Знач ИменаКолонок,
	                                  ОписаниеОповещения = Неопределено) Экспорт
	
	МассивКолонок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ИменаКолонок, ",");
	
	Если МассивКолонок.Количество() = 5 Тогда
		ПоказыватьСклад = ЗначениеЗаполнено(МассивКолонок[3]);
		ПоказыватьДату = ЗначениеЗаполнено(МассивКолонок[4]);
	ИначеЕсли МассивКолонок.Количество() = 4 Тогда
		ПоказыватьСклад = ЗначениеЗаполнено(МассивКолонок[3]);
		ПоказыватьДату = Ложь;
	ИначеЕсли МассивКолонок.Количество() = 3 Тогда
		ПоказыватьСклад = Ложь;
		ПоказыватьДату = Ложь;
	Иначе
		ВызватьИсключение НСтр("ru = 'Неверно задан параметр ИменаКолонок функции'");
	КонецЕсли;
	
	Если Форма.Объект[ИмяТаблицы].Количество() = 0 Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'В списке отсутствуют строки. Дозаполнение многооборотной тарой не требуется.'"));
		
		Если ОписаниеОповещения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОписаниеОповещения, Ложь);
		КонецЕсли;
		
		Возврат;
		
	КонецЕсли;
	
	АдресТоваровВоВременномХранилище = МногооборотнаяТараВызовСервера.ПоместитьТоварыДляПодбораТарыВоВременноеХранилище(
		Форма.Объект,
		ИмяТаблицы,
		ИменаКолонок,
		Форма.УникальныйИдентификатор,
		ПоказыватьСклад,
		ПоказыватьДату);
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("АдресТоваровВоВременномХранилище", АдресТоваровВоВременномХранилище);
	СтруктураПараметров.Вставить("ПоказыватьСклад", ПоказыватьСклад);
	СтруктураПараметров.Вставить("ПоказыватьДату", ПоказыватьДату);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("ОписаниеОповещения", ОписаниеОповещения);
	ОткрытьФорму(
		"Обработка.ПодборМногооборотнойТары.Форма.Форма",
		СтруктураПараметров,
		Форма,,,,
		Новый ОписаниеОповещения("ПодобратьМногооборотнуюТаруПодборТарыЗавершение", МногооборотнаяТараКлиент, ДополнительныеПараметры));
	
КонецПроцедуры

// Обработчик завершения подбора многооборотной тары.
//
// Параметры:
//  СтруктураВозврата - Структура, Неопределено - необходимые данные для определения состояния подбора многооборотной тары.
//  ДополнительныеПараметры - Структура - дополнительные параметры.
//
Процедура ПодобратьМногооборотнуюТаруПодборТарыЗавершение(СтруктураВозврата, ДополнительныеПараметры) Экспорт
	
	ЕстьСостояниеЗаполненияМногооборотнойТары = ОбщегоНазначенияУТКлиентСервер.ЕстьРеквизитОбъекта(
		ДополнительныеПараметры.Форма.Объект, "СостояниеЗаполненияМногооборотнойТары");
	
	Если СтруктураВозврата = Неопределено Тогда
		
		Если ЕстьСостояниеЗаполненияМногооборотнойТары Тогда
			ДополнительныеПараметры.Форма.Объект.СостояниеЗаполненияМногооборотнойТары = ПредопределенноеЗначение("Перечисление.СостоянияЗаполненияМногооборотнойТары.ПредлагатьЗаполнить");
		КонецЕсли;
		
		Если ДополнительныеПараметры.ОписаниеОповещения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещения, Ложь);
		КонецЕсли;
	
	Иначе
		
		Если ЕстьСостояниеЗаполненияМногооборотнойТары Тогда
			Если СтруктураВозврата.ТараПодобрана Тогда
				ДополнительныеПараметры.Форма.Объект.СостояниеЗаполненияМногооборотнойТары = ПредопределенноеЗначение("Перечисление.СостоянияЗаполненияМногооборотнойТары.Заполнена");
			Иначе
				ДополнительныеПараметры.Форма.Объект.СостояниеЗаполненияМногооборотнойТары = ПредопределенноеЗначение("Перечисление.СостоянияЗаполненияМногооборотнойТары.ПредлагатьЗаполнить");
			КонецЕсли;
		КонецЕсли;
		
		Если ДополнительныеПараметры.ОписаниеОповещения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещения, СтруктураВозврата.ТараПодобрана);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Показывает оповещения пользователю после добавление многооборотной тары в документ
//
Процедура ОповеститьПользователяОЗаполненииМногооборотнойТарой() Экспорт
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Подбор многооборотной тары'"),
		,
		НСтр("ru = 'Подбор многооборотной тары завершен.'"));
	
КонецПроцедуры

// Предлагает пользователю дополнить товары документа многооборотной тарой
// Если пользователь согласился - открывает форму подбора многооборотной тары
//
// Параметры:
// Форма - УправляемаяФорма - Форма, из которой подбирается многооборотная тара
// ИмяТаблицы - Строка - Имя таблицы с товарами и тарой документа
// ИменаКолонок - Строка - Имена колонок таблицы с товарами и тарой документа, разделенные запятыми
//
Процедура ПредложитьПодобратьМногооборотнуюТару(Знач Форма,
	                                            Знач ИмяТаблицы,
	                                            Знач ИменаКолонок,
	                                            ОписаниеОповещения) Экспорт
	
	Состояние = Форма.Объект.СостояниеЗаполненияМногооборотнойТары;
	СостояниеЗаполнено = ЗначениеЗаполнено(Состояние);
	ЗадаватьВопрос = Ложь;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("ИмяТаблицы", ИмяТаблицы);
	ДополнительныеПараметры.Вставить("ИменаКолонок", ИменаКолонок);
	ДополнительныеПараметры.Вставить("ОписаниеОповещения", ОписаниеОповещения);
	
	Если Форма.Объект[ИмяТаблицы].Количество() = 0 Или
		(СостояниеЗаполнено
			И (Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЗаполненияМногооборотнойТары.НеПредлагатьЗаполнить")
				Или Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЗаполненияМногооборотнойТары.Заполнена"))) Тогда
		
		ЗадаватьВопрос = Ложь;
		
	ИначеЕсли Состояние = ПредопределенноеЗначение("Перечисление.СостоянияЗаполненияМногооборотнойТары.ПредлагатьЗаполнить") Или
		Не СостояниеЗаполнено Тогда
		
		ЗадаватьВопрос = МногооборотнаяТараВызовСервера.ЗадаватьВопросОЗаполненииМногооборотнойТарой(
			Форма.Объект,
			ИмяТаблицы,
			ИменаКолонок);
		
	Иначе
		
		ЗадаватьВопрос = Ложь;
		
	КонецЕсли;
	
	Если Не ЗадаватьВопрос Тогда
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, Ложь);
		Возврат;
	КонецЕсли;
	
	ВариантыОтвета = Новый СписокЗначений();
	ВариантыОтвета.Добавить("Дополнить", НСтр("ru = 'Дополнить'"));
	ВариантыОтвета.Добавить("НеДополнять", НСтр("ru = 'Не дополнять'"));
	
	ПоказатьВопрос(
		Новый ОписаниеОповещения("ПредложитьПодобратьМногооборотнуюТаруВопросДополнитьТаройЗавершение", МногооборотнаяТараКлиент, ДополнительныеПараметры),
		НСтр("ru = 'Дополнить многооборотной тарой?'"),
		ВариантыОтвета);
	
КонецПроцедуры

// Обработчик завершения вопроса о предложении заполнения многооборотной тарой.
//
// Параметры:
//  ОтветНаВопрос           - Строка - вариант ответа на вопрос, выбранный пользователем.
//  ДополнительныеПараметры - Структура - дополнительные параметры.
//
Процедура ПредложитьПодобратьМногооборотнуюТаруВопросДополнитьТаройЗавершение(ОтветНаВопрос, ДополнительныеПараметры) Экспорт
	
	Если ОтветНаВопрос = "НеДополнять" Тогда
		
		ДополнительныеПараметры.Форма.Объект.СостояниеЗаполненияМногооборотнойТары = ПредопределенноеЗначение("Перечисление.СостоянияЗаполненияМногооборотнойТары.НеПредлагатьЗаполнить");
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещения, Ложь);
		
	Иначе
		
		ПодобратьМногооборотнуюТару(
			ДополнительныеПараметры.Форма,
			ДополнительныеПараметры.ИмяТаблицы,
			ДополнительныеПараметры.ИменаКолонок,
			Новый ОписаниеОповещения("ПредложитьПодобратьМногооборотнуюТаруПодборТарыЗавершение", МногооборотнаяТараКлиент, ДополнительныеПараметры));
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик завершения вопроса о предложении заполнения многооборотной тарой.
//
// Параметры:
//  ТараПодобрана - Булево - Истина, если тара подобрана.
//  ДополнительныеПараметры - Структура - дополнительные параметры.
//
Процедура ПредложитьПодобратьМногооборотнуюТаруПодборТарыЗавершение(ТараПодобрана, ДополнительныеПараметры) Экспорт
	
	Если ТараПодобрана Тогда
		ДополнительныеПараметры.Форма.Объект.СостояниеЗаполненияМногооборотнойТары = ПредопределенноеЗначение("Перечисление.СостоянияЗаполненияМногооборотнойТары.Заполнена");
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещения, ТараПодобрана);
	
КонецПроцедуры

// Сбрасывает состояние заполнения многооборотной тары в документе после изменения табличной части
//
// Параметры:
// СостояниеЗаполненияМногооборотнойТары - ПеречислениеСсылка.СостоянияЗаполненияМногооборотнойТары
//
Процедура ОбновитьСостояниеЗаполненияМногооборотнойТары(СостояниеЗаполненияМногооборотнойТары) Экспорт
	
	Если СостояниеЗаполненияМногооборотнойТары = ПредопределенноеЗначение("Перечисление.СостоянияЗаполненияМногооборотнойТары.Заполнена") Тогда
		СостояниеЗаполненияМногооборотнойТары = ПредопределенноеЗначение("Перечисление.СостоянияЗаполненияМногооборотнойТары.ПредлагатьЗаполнить");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
