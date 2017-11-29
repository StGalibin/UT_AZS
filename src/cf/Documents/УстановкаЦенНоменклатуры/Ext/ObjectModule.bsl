﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);

	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);

	ОбщегоНазначенияУТ.ИзменитьПризнакСогласованностиДокумента(ЭтотОбъект, РежимЗаписи, Перечисления.СтатусыУстановокЦенНоменклатуры.НеСогласован);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСогласованиеЦенНоменклатуры") 
	 И Статус = Перечисления.СтатусыУстановокЦенНоменклатуры.Согласован
	 И Не ПраваПользователяПовтИсп.УстановкаЦенНоменклатурыБезСогласования() Тогда
		
		ТекстОшибки = НСтр("ru='Нет прав на установку цен номенклатуры без согласования'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			Ссылка,
			,
			,
			Отказ);
			
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПриобретениеТоваровУслуг") Тогда
		
		ЗаполнитьПоПоступлениюТоваровУслуг(
			ДанныеЗаполнения,
			ДанныеЗаполнения);
	
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеТоваров") Тогда
		
		ЗаполнитьПоПоступлениюТоваров(
			ДанныеЗаполнения,
			ДанныеЗаполнения);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказПоставщику") Тогда
		
		ЗаполнитьПоЗаказуПоставщику(
			ДанныеЗаполнения,
			ДанныеЗаполнения);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПорчаТоваров") Тогда
		
		ЗаполнитьПоПорчеТоваров(
			ДанныеЗаполнения,
			ДанныеЗаполнения);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.СборкаТоваров") Тогда
		
		ЗаполнитьПоСборкеТоваров(
			ДанныеЗаполнения,
			ДанныеЗаполнения);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПрочееОприходованиеТоваров") Тогда
		
		ЗаполнитьПоПрочемуОприходованиюТоваров(
			ДанныеЗаполнения,
			ДанныеЗаполнения);
		
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ИзменениеАссортимента") Тогда
		
		ЗаполнитьПоИзменениюАссортимента(
			ДанныеЗаполнения,
			ДанныеЗаполнения);
	КонецЕсли;
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	Документы.УстановкаЦенНоменклатуры.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);

	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	Ценообразование.ОтразитьЦеныНоменклатуры(ДополнительныеСвойства, Движения, Отказ);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)

	ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);

	ПроведениеСерверУТ.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);

	ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)

	ИнициализироватьДокумент();
	Согласован = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// См. описание в комментарии к одноименной процедуре в модуле УправлениеДоступом.
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	Если ВидыЦен.Количество() = 0 Тогда
		
		Строка = Таблица.Добавить();
		Строка.ЗначениеДоступа = Перечисления.ДополнительныеЗначенияДоступа.ДоступРазрешен;
		
	Иначе
	
		Для Каждого СтрокаВидыЦен Из ВидыЦен Цикл
			Строка = Таблица.Добавить();
			Строка.ЗначениеДоступа = СтрокаВидыЦен.ВидЦены;
		КонецЦикла;
		
	КонецЕсли;
	 
КонецПроцедуры

#Область ИнициализацияИЗаполнение

// Процедура заполнения документа на основании заявки на возврат товаров от клиента.
//
// Параметры:
//	ДокументОснование - ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента - Ссылка на заявку
//	ДанныеЗаполнения - Структура - Данные заполнения документа
//	
Процедура ЗаполнитьПоПоступлениюТоваровУслуг(
	Знач ДокументОснование,
	ДанныеЗаполнения)
	
	// Заполним данные шапки документа.
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВидыЦен.Ссылка,
	|	ВидыЦен.УстанавливатьЦенуПриВводеНаОсновании,
	|	ВидыЦен.ПометкаУдаления
	|ПОМЕСТИТЬ ВидыЦен
	|ИЗ
	|	Справочник.ВидыЦен КАК ВидыЦен
	|ГДЕ
	|	ВидыЦен.УстанавливатьЦенуПриВводеНаОсновании
	|	И ВидыЦен.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыДействияВидовЦен.Действует)
	|	И НЕ ВидыЦен.ПометкаУдаления
	|;
	|
	|ВЫБРАТЬ
	|	ПриобретениеТоваровУслугТовары.Номенклатура КАК Номенклатура,
	|	ПриобретениеТоваровУслугТовары.Характеристика КАК Характеристика,
	|	ПриобретениеТоваровУслугТовары.Упаковка КАК Упаковка,
	|	ВидыЦен.Ссылка КАК ВидЦены,
	|	0 КАК Цена
	|ИЗ
	|	Документ.ПриобретениеТоваровУслуг.Товары КАК ПриобретениеТоваровУслугТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВидыЦен КАК ВидыЦен
	|		ПО Истина
	|ГДЕ
	|	ПриобретениеТоваровУслугТовары.Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не требуется вводить установку цен номенклатуры на основании документа %1'"),
			ДокументОснование);
		ВызватьИсключение Текст;
	Иначе
		
		ЭтотОбъект.ДокументОснование = ДокументОснование;
		Товары.Загрузить(РезультатЗапроса.Выгрузить());
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура заполнения документа на основании поступления товаров
//
// Параметры:
//	ДокументОснование - ДокументСсылка.ПоступлениеТоваров - Ссылка на поступление
//	ДанныеЗаполнения - Структура - Данные заполнения документа
//	
Процедура ЗаполнитьПоПоступлениюТоваров(
	Знач ДокументОснование,
	ДанныеЗаполнения)
	
	// Заполним данные шапки документа.
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	ТаблицаТовары.Упаковка КАК Упаковка,
	|	ВидыЦен.Ссылка КАК ВидЦены,
	|	0 КАК Цена
	|ИЗ
	|	Документ.ПоступлениеТоваров.Товары КАК ТаблицаТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыЦен КАК ВидыЦен
	|		ПО (ВидыЦен.УстанавливатьЦенуПриВводеНаОсновании)
	|			И (НЕ ВидыЦен.ПометкаУдаления)
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не требуется вводить установку цен номенклатуры на основании документа %1'"),
			ДокументОснование);
		ВызватьИсключение Текст;
	Иначе
		
		ЭтотОбъект.ДокументОснование = ДокументОснование;
		Товары.Загрузить(РезультатЗапроса.Выгрузить());
		
	КонецЕсли;
	
КонецПроцедуры


// Процедура заполнения документа на основании заявки на возврат товаров от клиента.
//
// Параметры:
//	ДокументОснование - ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента - Ссылка на заявку
//	ДанныеЗаполнения - Структура - Данные заполнения документа
//	
Процедура ЗаполнитьПоЗаказуПоставщику(
	Знач ДокументОснование,
	ДанныеЗаполнения)
	
	// Заполним данные шапки документа.
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЗаказПоставщикуТовары.Номенклатура   КАК Номенклатура,
	|	ЗаказПоставщикуТовары.Характеристика КАК Характеристика,
	|	ЗаказПоставщикуТовары.Упаковка       КАК Упаковка
	|ИЗ
	|	Документ.ЗаказПоставщику.Товары КАК ЗаказПоставщикуТовары
	|ГДЕ
	|	ЗаказПоставщикуТовары.Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не требуется вводить установку цен номенклатуры на основании документа %1'"),
			ДокументОснование);
		ВызватьИсключение Текст;
	Иначе
		
		ЭтотОбъект.ДокументОснование = ДокументОснование;
		Товары.Загрузить(РезультатЗапроса.Выгрузить());
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура заполнения документа на основании заявки на возврат товаров от клиента.
//
// Параметры:
//	ДокументОснование - ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента - Ссылка на заявку
//	ДанныеЗаполнения - Структура - Данные заполнения документа
//	
Процедура ЗаполнитьПоПорчеТоваров(
	Знач ДокументОснование,
	ДанныеЗаполнения)
	
	// Заполним данные шапки документа.
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ПорчаТоваровТовары.НоменклатураОприходование           КАК Номенклатура,
	|	ПорчаТоваровТовары.ХарактеристикаОприходование         КАК Характеристика,
	|	ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка) КАК Упаковка
	|ИЗ
	|	Документ.ПорчаТоваров.Товары КАК ПорчаТоваровТовары
	|ГДЕ
	|	ПорчаТоваровТовары.Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не требуется вводить установку цен номенклатуры на основании документа %1'"),
			ДокументОснование);
		ВызватьИсключение Текст;
	Иначе
		
		ЭтотОбъект.ДокументОснование = ДокументОснование;
		Товары.Загрузить(РезультатЗапроса.Выгрузить());
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура заполнения документа на основании сборки товаров.
//
// Параметры:
//	ДокументОснование - ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента - Ссылка на заявку
//	ДанныеЗаполнения - Структура - Данные заполнения документа
//	
Процедура ЗаполнитьПоСборкеТоваров(
	Знач ДокументОснование,
	ДанныеЗаполнения)
	
	// Заполним данные шапки документа.
	Запрос = Новый Запрос(
	"
	|ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Упаковка КАК Упаковка
	|ИЗ
	|	Документ.СборкаТоваров.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|	И Товары.Ссылка.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.РазборкаТоваров)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДокументСборкаТоваров.Номенклатура КАК Номенклатура,
	|	ДокументСборкаТоваров.Характеристика КАК Характеристика,
	|	ДокументСборкаТоваров.Упаковка КАК Упаковка
	|ИЗ
	|	Документ.СборкаТоваров КАК ДокументСборкаТоваров
	|ГДЕ
	|	ДокументСборкаТоваров.Ссылка = &Ссылка
	|	И ДокументСборкаТоваров.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.СборкаТоваров)
	|
	|");
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не требуется вводить установку цен номенклатуры на основании документа %1'"),
			ДокументОснование);
		ВызватьИсключение Текст;
	Иначе
		
		ЭтотОбъект.ДокументОснование = ДокументОснование;
		Товары.Загрузить(РезультатЗапроса.Выгрузить());
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура заполнения документа на основании прочего оприходования товаров.
//
// Параметры:
//	ДокументОснование - ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента - Ссылка на заявку
//	ДанныеЗаполнения - Структура - Данные заполнения документа
//	
Процедура ЗаполнитьПоПрочемуОприходованиюТоваров(
	Знач ДокументОснование,
	ДанныеЗаполнения)
	
	// Заполним данные шапки документа.
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Товары.Номенклатура           КАК Номенклатура,
	|	Товары.Характеристика         КАК Характеристика,
	|	Товары.Упаковка               КАК Упаковка
	|ИЗ
	|	Документ.ПрочееОприходованиеТоваров.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", ДокументОснование);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не требуется вводить установку цен номенклатуры на основании документа %1'"),
			ДокументОснование);
		ВызватьИсключение Текст;
	Иначе
		
		ЭтотОбъект.ДокументОснование = ДокументОснование;
		Товары.Загрузить(РезультатЗапроса.Выгрузить());
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура заполнения документа на основании изменения ассортимента.
//
// Параметры:
//	ДокументОснование - ДокументСсылка.ИзменениеАссортимента - ссылка на документ
//	ДанныеЗаполнения - Структура - Данные заполнения документа
//	
Процедура ЗаполнитьПоИзменениюАссортимента(
	Знач ДокументОснование,
	ДанныеЗаполнения)
	
	АссортиментСервер.ПроверитьНеобходимостьУстановкиЦенНаОсновании(ДанныеЗаполнения.Ссылка);
	
	РезультатПакетаВидыЦенИТовары = АссортиментСервер.РезультатПакетаВидыЦенИТоварыДляУстановкиПоАссортименту(ДанныеЗаполнения.Ссылка);
	ТаблицаВидовЦен   = РезультатПакетаВидыЦенИТовары[1].Выгрузить();
	ТаблицаТоваров    = РезультатПакетаВидыЦенИТовары[0].Выгрузить();
	
	Если ТаблицаВидовЦен.Количество() = 0 Тогда
		
		ТекстОшибки = НСтр("ru='Нет доступных видов цен для установки цен номенклатуры.
		|Оформление документа не требуется. 
		|Заполнение документа не выполнено.'");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ДанныеЗаполнения.Ссылка);
		
		ВызватьИсключение ТекстОшибки;
		
	Иначе	
		
		ЭтотОбъект.ДокументОснование = ДокументОснование;
		ВидыЦен.Загрузить(ТаблицаВидовЦен);
		Товары.Загрузить(ТаблицаТоваров);
		
	КонецЕсли;
	
КонецПроцедуры


// Инициализирует установку цен номенклатуры.
//
Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Ответственный = Пользователи.ТекущийПользователь();

	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСогласованиеЦенНоменклатуры")
	 Или ПраваПользователяПовтИсп.УстановкаЦенНоменклатурыБезСогласования() Тогда
		Статус = Перечисления.СтатусыУстановокЦенНоменклатуры.Согласован;
	Иначе
	    Статус = Перечисления.СтатусыУстановокЦенНоменклатуры.НеСогласован;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
