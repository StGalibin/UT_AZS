﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция получает элемент справочника - ключ аналитики учета номенклатураы.
//
// Параметры:
//	ПараметрыАналитики - Выборка, Структура - Содержит полями "Номенклатура, Характеристика, Склад, Назначение, СтатьяКалькуляции":
//		* Номенклатура - СправочникСсылка.Номенклатура.
//		* Характеристика - СправочникСсылка.ХарактиристикиНоменклатуры.
//		* Склад - СправочникСсылка.Склады, ПеречислениеСсылка.СтруктураПредприятия.
//		* СтатьяКалькуляции - СправочникСсылка.СтатьиКалькуляции.
//
// Возвращаемое значение:
//	СправочникСсылка.КлючиАналитикиУчетаНоменклатуры - Созданный элемент справочника
//
Функция ЗначениеКлючаАналитики(ПараметрыАналитики) Экспорт

	НаборЗаписей = ПолучитьНаборЗаписей(ПараметрыАналитики);
	
	Если НаборЗаписей <> Неопределено Тогда
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() > 0
			И Не ЗначениеЗаполнено(НаборЗаписей[0].КлючАналитики) Тогда
			НаборЗаписей.Очистить();
			НаборЗаписей.Записать();
		КонецЕсли;

		Если НаборЗаписей.Количество() > 0
			И ЗначениеЗаполнено(НаборЗаписей[0].КлючАналитики) Тогда
			Результат = НаборЗаписей[0].КлючАналитики;
		Иначе
			Результат = СоздатьКлючАналитики(ПараметрыАналитики);
		КонецЕсли;

		Возврат Результат;
	КонецЕсли;

КонецФункции

// Функция получает элемент справочника - ключ аналитики учета.
//
// Параметры:
//	ПараметрыАналитики - Выборка или Структура  с полями "Номенклатура, Характеристика, Склад, Назначение".
//
// Возвращаемое значение:
//	СправочникСсылка.КлючиАналитикиУчетаНоменклатуры - Созданный элемент справочника
//
Функция СоздатьКлючАналитики(ПараметрыАналитики, ЗаписьПриОбновленииИБ = Ложь) Экспорт
	
	Если ЗначениеЗаполнено(ПараметрыАналитики.Номенклатура) Тогда
		НаборЗаписей = ПолучитьНаборЗаписей(ПараметрыАналитики);
		
		Если НаборЗаписей <> Неопределено Тогда
			
			НачатьТранзакцию(); // Создание нового ключа аналитики.
			Попытка
				СтрокаНабора = НаборЗаписей[0];
				
				СправочникОбъект = Справочники.КлючиАналитикиУчетаНоменклатуры.СоздатьЭлемент();
				СправочникОбъект.Наименование = ПолучитьПолноеНаименованиеКлючаАналитики(СтрокаНабора);
				ЗаполнитьЗначенияСвойств(СправочникОбъект, СтрокаНабора, "Номенклатура, Характеристика, Серия, Склад, Назначение, СтатьяКалькуляции");
				Если ЗаписьПриОбновленииИБ Тогда
					ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СправочникОбъект);
				Иначе
					СправочникОбъект.Записать();
				КонецЕсли;

				Результат = СправочникОбъект.Ссылка;

				СтрокаНабора.КлючАналитики = Результат;
				
				Если ЗаписьПриОбновленииИБ Тогда
					ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей, Ложь, Истина);
				Иначе
					НаборЗаписей.Записать(Ложь);
				КонецЕсли;
				ЗафиксироватьТранзакцию();
			Исключение
				// во время инициализации ключа, данный ключ уже был создан в ИБ другим сеансом.
				НаборЗаписей.Прочитать();
				Если Не НаборЗаписей.Количество() = 0 Тогда // запись не создана из-за ошибки заполнения полей.
					ОтменитьТранзакцию();
					ВызватьИсключение;
				Иначе
					ОтменитьТранзакцию();
					Результат = НаборЗаписей[0].КлючАналитики;
				КонецЕсли;
			КонецПопытки;

			Возврат Результат;
			
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

// Возвращает параметры генерации ключей аналитики. Используется в обработчиках обновления.
// Возвращаемое значение:
//	Структура - Структура содержит поля: ЕстьНеобработанныеКлючи, ИзмененаАналитика, СоздаватьНовыеКлючи.
Функция ПараметрыЗаполненияКлючейАналитики() Экспорт
	Возврат Новый Структура("ИзмененаАналитика,СоздаватьВКлючи", Ложь, Истина);
КонецФункции

// Заполняет поле АналитикаУчетаНоменклатуры в коллекции, содержащей номенклатуру, характеристику, серию, склад, назначение.
// Места учета и имена полей для мест учета трактуются следующим образом:
//	для ключей, кроме Произвольный:
//		если имя поля указано (есть ключ в структуре) и значение заполнено, то выбирать данные из этого поля коллекции;
//		если имя поля указано, но значение не заполнено ("" или Неопределено), то данные всегда устанавливать из мест учета;
//		если имя поля не указано, то смотрится заполнение ключа Произвольный;
//	для ключа Произвольный:
//		если значение имени поля заполнено, то все типы номенклатуры, которые не упомянуты в других ключах, выбирают
//		данные из этого поля коллекции, если в поле коллекции значение не задано, то данные устанавливаются из мест учета;
//		если значение поля не заполнено, то данные всегда устанавливаются из мест учета;
//
// Параметры:
//
//	Коллекция - ТабличнаяЧасть - Коллекция, в которой производится заполнение аналитики учета номенклатуры.
//
//	МестаУчета - Структура - места учета типов номенклатуры:
//		* Произвольный - СправочникСсылка.Склады, ПеречислениеСсылка.СтруктураПредприятияя - [, Товар, МногооборотнаяТара, Услуга, Работа]},
//			ключ Произвольный обязателен. Задает значения общих места учета по типам номенклатуры и определяет, как заполняется поле Склад в аналитике,
//			если в коллекции нет данных для заполнения (нет полей или поле не заполнено).
//			для примера см. метод МестаУчета(...)
//		* Работа - СправочникСсылка.Склады, ПеречислениеСсылка.СтруктураПредприятияя - место учета работы.
//
//	ИменаПолей - Структура - содержит реальные имена полей коллекции для получения и формирования аналитики.
//		содержит две секции, если значение ключа Неопределено, то имя поля берется из имени ключа.
//		секция идентификации {Номенклатура, Характеристика, АналитикаУчетаНоменклатуры [, СтатусУказанияСерий, Серия]},
//			ключи определения полей серии необязательны, использование серий определяется по полю СтатусУказанияСерий.
//		секция места учета {Произвольный [, Товар, МногооборотнаяТара, Услуга, Работа]}, ключ Произвольный обязателен.
//		по умолчанию заполняется методом ИменаПолейКоллекцииПоУмолчанию(...)
//			("Номенклатура, Характеристика, Серия, Назначение, АналитикаУчетаНоменклатуры, Произвольный, Работа",
//			"Номенклатура", "Характеристика", "Серия", "Назначение", "АналитикаУчетаНоменклатуры", "", "")
//	ДополнитьКлюч - Булево - Используется в обработчиках обновления, при работе с таб.частью ВидыЗапасов
//	
//	ПараметрыЗаполнения - Структура - см. метод ПараметрыЗаполненияКлючейАналитики()
//
// Пример 1:
//	МестаУчета = РегистрыСведений.АналитикаУчетаНоменклатуры.МестаУчета(
//		ЭтотОбъект.ХозяйственнаяОперация, ЭтотОбъект.СкладОтправитель, Неопределено, Неопределено);
//	ИменаПолей = РегистрыСведений.АналитикаУчетаНоменклатуры.ИменаПолейКоллекцииПоУмолчанию();
//	ИменаПолей.СтатусУказанияСерий = "СтатусУказанияСерийОтправитель";
//	РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(Товары, МестаУчета, ИменаПолей);
//
// Пример 2:
//	МестаУчета = Новый Структура("Произвольный, Работа", ЭтотОбъект.Партнер, ЭтотОбъект.Подразделение)
//	РегистрыСведений.АналитикаУчетаНоменклатуры.ЗаполнитьВКоллекции(Товары, МестаУчета);
//
Процедура ЗаполнитьВКоллекции(Коллекция, МестаУчета, ИменаПолей = Неопределено, ДополнитьКлюч = Ложь, ПараметрыЗаполнения = Неопределено) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	Если ПараметрыЗаполнения = Неопределено Тогда
		ПараметрыЗаполнения = ПараметрыЗаполненияКлючейАналитики();
	КонецЕсли;
	
	Если ДополнитьКлюч Тогда
		Если ИменаПолей = Неопределено Тогда
			ИменаПолей = ИменаПолейДополненияКоллекцииПоУмолчанию();
		КонецЕсли;
		Запрос = Новый Запрос(ТекстДополнениеКлючейАналитикиВКоллекции(ИменаПолей));
		Запрос.УстановитьПараметр("Коллекция", Коллекция);
		Запрос.УстановитьПараметр("Склад", ?(МестаУчета.Свойство("Товар"), МестаУчета.Товар, МестаУчета.Произвольный));
	Иначе
		Если ИменаПолей = Неопределено Тогда
			ИменаПолей = ИменаПолейКоллекцииПоУмолчанию();
		КонецЕсли;
		Запрос = Новый Запрос(ТекстЗначенияКлючейАналитикиВКоллекции(ИменаПолей));
		Запрос.УстановитьПараметр("Коллекция", Коллекция);
		Запрос.УстановитьПараметр("МестаУчетаТовар", ?(МестаУчета.Свойство("Товар"), МестаУчета.Товар, МестаУчета.Произвольный));
		Запрос.УстановитьПараметр("МестаУчетаМногооборотнаяТара", ?(МестаУчета.Свойство("МногооборотнаяТара"), МестаУчета.МногооборотнаяТара, МестаУчета.Произвольный));
		Запрос.УстановитьПараметр("МестаУчетаУслуга", ?(МестаУчета.Свойство("Услуга"), МестаУчета.Услуга, МестаУчета.Произвольный));
		Запрос.УстановитьПараметр("МестаУчетаРабота", ?(МестаУчета.Свойство("Работа"), МестаУчета.Работа, МестаУчета.Произвольный));
		
		Если ЗначениеЗаполнено(ИменаПолей.Назначение)
			И ТипЗнч(ИменаПолей.Назначение) = Тип("Структура")
			И ИменаПолей.Назначение.Свойство("Значение") Тогда
			Запрос.УстановитьПараметр("Назначение", ИменаПолей.Назначение.Значение);
		КонецЕсли;
		
	КонецЕсли;
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Не ЗначениеЗаполнено(Выборка.АналитикаУчетаНоменклатуры) Тогда
			Если ПараметрыЗаполнения.СоздаватьВКлючи Тогда
				КлючАналитики = ЗначениеКлючаАналитики(Выборка);
			Иначе
				ТекстИсключения = НСтр("ru = 'Ошибка при заполнении ключей в коллекции: есть аналитики, по которым ключи еще не созданы.'");
				ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
					УровеньЖурналаРегистрации.Ошибка,
					Метаданные.Справочники.КлючиАналитикиУчетаНоменклатуры,
					,
					ТекстИсключения);
				ВызватьИсключение ТекстИсключения;
			КонецЕсли;
		Иначе
			КлючАналитики = Выборка.АналитикаУчетаНоменклатуры;
		КонецЕсли;
		Если ДополнитьКлюч Тогда
			Коллекция[Выборка.Индекс][ИменаПолей.ЗаполняемаяАналитикаУчетаНоменклатуры] = КлючАналитики;
		Иначе
			Коллекция[Выборка.Индекс][ИменаПолей.АналитикаУчетаНоменклатуры] = КлючАналитики;
		КонецЕсли;
		ПараметрыЗаполнения.ИзмененаАналитика = Истина;
	КонецЦикла;
КонецПроцедуры

// Формирует структуру, определяющую, какие места учета использовать для различных типов номенклатуры
// при заполнении ключей аналитики в табчастях товаров.
//
// Параметры:
//	Операция - ПеречислениеСсылка.ХозяйственныеОперации, ПеречислениеСсылка.ТипыОперацийВводаОстатков - Хоз.операция документа.
//	Склад - СправочникСсылка.Склады - Склад, по которому формируется ключ.
//	Подразделение - СправочникСсылка.СтруктураПредприятия - Подразделение, по которому формируется ключ.
//	Партнер - СправочникСсылка.Партнеры - Партнер, по которому формируется ключ.
//
// Возвращаемое значение:
//	Структура:
//		* Произвольный - Содержит место учета по-умолчанию.
//		* Работа - Содержит место учета для работ.
//
Функция МестаУчета(Операция, Склад, Подразделение, Партнер) Экспорт
	Хозоперации = Перечисления.ХозяйственныеОперации;
	ОперацииОстатков = Перечисления.ТипыОперацийВводаОстатков;
	
	СкладУчета = ?(Склад = Неопределено, Справочники.Склады.ПустаяСсылка(), Склад);
	ПодразделениеУчета = ?(Подразделение = Неопределено, Справочники.СтруктураПредприятия.ПустаяСсылка(), Подразделение);
	ПартнерУчета = ?(Партнер = Неопределено, Справочники.Партнеры.ПустаяСсылка(), Партнер);
	
	МестаУчета = Новый Структура("Произвольный, Работа");
	
	ИспользоватьПартнера =
		(Операция = Хозоперации.ОтчетКомиссионера)
		Или (Операция = Хозоперации.ОтчетКомитенту)
		Или (Операция = Хозоперации.ПроизводствоУПереработчика)
		Или (Операция = ОперацииОстатков.ОстаткиТоваровПереданныхНаКомиссию)
		Или (Операция = ОперацииОстатков.ОстаткиВозвратнойТарыПереданнойКлиентам)
		Или (Операция = ОперацииОстатков.ОстаткиМатериаловПереданныхПереработчикам)
		Или (Операция = Хозоперации.ЗакупкаВСтранахЕАЭСТоварыВПути)
		Или (Операция = Хозоперации.ЗакупкаПоИмпортуТоварыВПути)
		Или (Операция = Хозоперации.ЗакупкаУПоставщикаТоварыВПути)
		Или (Операция = Хозоперации.ЗакупкаВСтранахЕАЭСФактуровкаПоставки)
		Или (Операция = Хозоперации.ЗакупкаУПоставщикаФактуровкаПоставки);
		
	
	МестаУчета.Произвольный = ?(ИспользоватьПартнера, ПартнерУчета, СкладУчета);
	МестаУчета.Работа = ПодразделениеУчета;
	
	Возврат МестаУчета;
КонецФункции

// Возвращает структуру полей выбора информации из коллекции для формирования аналитики учета номенклатуры.
//
// Возвращаемое значение:
//	Структура - содержит реальные имена полей коллекции для получения и формирования аналитики.
//		содержит две секции, если значение ключа Неопределено, то имя поля должно браться из имени ключа.
//		секция идентификации {Номенклатура, Характеристика, АналитикаУчетаНоменклатуры, СтатусУказанияСерий, Серия, Назначение},
//			все ключи заданы.
//		секция места учета {Произвольный, [Товар, ВозвратнаяТара, Услуга, ] Работа}, ключи Произвольный и Работа заданы.
//			реквизиты этой секции должны содержать имена колонок коллекции, откуда надо брать значения для одноименных
//			типов номенклатуры.
//
Функция ИменаПолейКоллекцииПоУмолчанию() Экспорт
	
	ИменаПолей = Новый Структура();
	ИменаПолей.Вставить("Номенклатура", "Номенклатура");
	ИменаПолей.Вставить("Характеристика", "Характеристика");
	ИменаПолей.Вставить("АналитикаУчетаНоменклатуры", "АналитикаУчетаНоменклатуры");
	ИменаПолей.Вставить("СтатусУказанияСерий", "СтатусУказанияСерий");
	ИменаПолей.Вставить("Серия", "Серия");
	ИменаПолей.Вставить("Назначение", "Назначение");
	ИменаПолей.Вставить("СтатьяКалькуляции", "");
	ИменаПолей.Вставить("Произвольный", "");
	ИменаПолей.Вставить("Работа", "");
	
	Возврат ИменаПолей;
КонецФункции

// Возвращает структуру полей выбора информации из коллекции для формирования аналитики учета номенклатуры.
//
// Возвращаемое значение:
//	Структура - содержит реальные имена полей коллекции для получения и формирования аналитики.
//
Функция ИменаПолейДополненияКоллекцииПоУмолчанию() Экспорт
	
	ИменаПолей = Новый Структура();
	ИменаПолей.Вставить("АналитикаУчетаНоменклатуры", "АналитикаУчетаНоменклатуры");
	ИменаПолей.Вставить("ЗаполняемаяАналитикаУчетаНоменклатуры", "АналитикаУчетаНоменклатуры");
	ИменаПолей.Вставить("Номенклатура", "");
	ИменаПолей.Вставить("Характеристика", "");
	ИменаПолей.Вставить("Серия", "");
	ИменаПолей.Вставить("Склад", "");
	ИменаПолей.Вставить("СтатьяКалькуляции", "");
	ИменаПолей.Вставить("ВидЗапасов", "ВидЗапасов");
	
	Возврат ИменаПолей;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Функция ПолучитьНаборЗаписей(ПараметрыАналитики)
	
	// В параметрах аналитики могут быть не все свойства
	СтруктураАналитики = Новый Структура("Номенклатура, Характеристика, Серия, Склад, Назначение, СтатьяКалькуляции");
	ЗаполнитьЗначенияСвойств(СтруктураАналитики, ПараметрыАналитики);
	Если НЕ ЗначениеЗаполнено(СтруктураАналитики.Номенклатура)
	 И НЕ ЗначениеЗаполнено(СтруктураАналитики.Характеристика)
	 И НЕ ЗначениеЗаполнено(СтруктураАналитики.Серия) 
	 И НЕ ЗначениеЗаполнено(СтруктураАналитики.Склад)
	 И НЕ ЗначениеЗаполнено(СтруктураАналитики.Назначение)
	 И НЕ ЗначениеЗаполнено(СтруктураАналитики.СтатьяКалькуляции) Тогда
		Возврат Неопределено
	Иначе
		НаборЗаписей = РегистрыСведений.АналитикаУчетаНоменклатуры.СоздатьНаборЗаписей();
		
		Для Каждого КлючЗначение из СтруктураАналитики Цикл
			НаборЗаписей.Отбор[КлючЗначение.Ключ].Установить(КлючЗначение.Значение);
		КонецЦикла;
		
		НоваяСтрока = НаборЗаписей.Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураАналитики, "Номенклатура, Характеристика, Серия, Склад, Назначение, СтатьяКалькуляции");
		ПроверитьЗаполнениеПоляСклад(НоваяСтрока);
		Возврат НаборЗаписей;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьПолноеНаименованиеКлючаАналитики(МенеджерЗаписи)

	Возврат СокрЛП(МенеджерЗаписи.Номенклатура) + "; " 
		+ ?(ЗначениеЗаполнено(МенеджерЗаписи.Характеристика), СокрЛП(МенеджерЗаписи.Характеристика) + "; ", "")
		+ ?(ЗначениеЗаполнено(МенеджерЗаписи.Серия), СокрЛП(МенеджерЗаписи.Серия) + "; ", "")
		+ ?(ЗначениеЗаполнено(МенеджерЗаписи.Назначение), СокрЛП(МенеджерЗаписи.Назначение) + "; ", "")
		+ ?(ЗначениеЗаполнено(МенеджерЗаписи.СтатьяКалькуляции), СокрЛП(МенеджерЗаписи.СтатьяКалькуляции) + "; ", "")
		+ СокрЛП(МенеджерЗаписи.Склад);

КонецФункции

Процедура ПроверитьЗаполнениеПоляСклад(МенеджерЗаписиАналитикаУчетаНоменклатуры)

	Если МенеджерЗаписиАналитикаУчетаНоменклатуры.Склад = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Ошибочное значение параметра ""Склад""'");
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеКлючейАналитикиВКоллекции

Функция ТекстЗначенияКлючейАналитикиВКоллекции(ИменаПолей)
	ТекстЗапроса = "
		|ВЫБРАТЬ
		|	Коллекция.НомерСтроки - 1 КАК Индекс,
		|	&ПолеАналитика КАК АналитикаУчетаНоменклатуры,
		|	&ПолеНоменклатура КАК Номенклатура,
		|	&ПолеХарактеристика КАК Характеристика,
		|	&ПолеНазначение КАК Назначение,
		|	&ПолеСтатьяКалькуляции КАК СтатьяКалькуляции,
		|	(ВЫБОР КОГДА &СтатусУказанияСерий В (14, 18) ТОГДА &ПолеСерия
		|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка) КОНЕЦ) КАК Серия,
		// места учета по типам номенклатуры
		|	(ВЫБОР КОГДА &ПолеСкладТовар В
		|		(ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка), ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка),
		|		ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка), НЕОПРЕДЕЛЕНО)
		|	ТОГДА &МестаУчетаТовар ИНАЧЕ &ПолеСкладТовар КОНЕЦ) КАК СкладТовар,
		|
		|	(ВЫБОР КОГДА &ПолеСкладМногооборотнаяТара В
		|		(ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка), ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка),
		|		ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка), НЕОПРЕДЕЛЕНО)
		|	ТОГДА &МестаУчетаМногооборотнаяТара ИНАЧЕ &ПолеСкладМногооборотнаяТара КОНЕЦ) КАК СкладМногооборотнаяТара,
		|
		|	(ВЫБОР КОГДА &ПолеСкладУслуга В
		|		(ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка), ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка),
		|		ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка), НЕОПРЕДЕЛЕНО)
		|	ТОГДА &МестаУчетаУслуга ИНАЧЕ &ПолеСкладУслуга КОНЕЦ) КАК СкладУслуга,
		|
		|	(ВЫБОР КОГДА &ПолеСкладРабота В
		|		(ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка), ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка),
		|		ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка), НЕОПРЕДЕЛЕНО)
		|	ТОГДА &МестаУчетаРабота ИНАЧЕ &ПолеСкладРабота КОНЕЦ) КАК СкладРабота
		|
		|ПОМЕСТИТЬ Коллекция
		|ИЗ &Коллекция КАК Коллекция;
		|
		|ВЫБРАТЬ
		|	Коллекция.Индекс,
		|	Аналитика.КлючАналитики КАК АналитикаУчетаНоменклатуры,
		|	Коллекция.Номенклатура,
		|	Коллекция.Характеристика,
		|	Коллекция.Серия,
		|	Коллекция.Назначение,
		|	Коллекция.СтатьяКалькуляции,
		|	(ВЫБОР СН.ТипНоменклатуры
		|		КОГДА ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар) ТОГДА Коллекция.СкладТовар
		|		КОГДА ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара) ТОГДА Коллекция.СкладМногооборотнаяТара
		|		КОГДА ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга) ТОГДА Коллекция.СкладУслуга
		|		КОГДА ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа) ТОГДА Коллекция.СкладРабота
		|		ИНАЧЕ Коллекция.СкладТовар
		|		КОНЕЦ) КАК Склад
		|ИЗ
		|	Коллекция КАК Коллекция
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК СН
		|		ПО СН.Ссылка = Коллекция.Номенклатура
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
		|		ПО Аналитика.Номенклатура = Коллекция.Номенклатура И Аналитика.Характеристика = Коллекция.Характеристика
		|		И Аналитика.Серия = Коллекция.Серия
		|		И Аналитика.Назначение = Коллекция.Назначение
		|		И Аналитика.СтатьяКалькуляции = Коллекция.СтатьяКалькуляции
		|		И Аналитика.Склад =
		|			(ВЫБОР СН.ТипНоменклатуры
		|				КОГДА ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар) ТОГДА Коллекция.СкладТовар
		|				КОГДА ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара) ТОГДА Коллекция.СкладМногооборотнаяТара
		|				КОГДА ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Услуга) ТОГДА Коллекция.СкладУслуга
		|				КОГДА ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Работа) ТОГДА Коллекция.СкладРабота
		|				ИНАЧЕ Коллекция.СкладТовар
		|				КОНЕЦ)
		|ГДЕ
		|	Аналитика.КлючАналитики ЕСТЬ NULL
		|	ИЛИ Аналитика.КлючАналитики <> Коллекция.АналитикаУчетаНоменклатуры
		|	ИЛИ Аналитика.КлючАналитики = ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаНоменклатуры.ПустаяСсылка)
		|";
	
	// заменим в тексте запроса подставляемые поля из структуры ИменаПолей
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеАналитика", "Коллекция." + ИменаПолей.АналитикаУчетаНоменклатуры);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеНоменклатура", "Коллекция." + ИменаПолей.Номенклатура);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеХарактеристика", "Коллекция." + ИменаПолей.Характеристика);
	
	// Поле назначение может отсутствовать в таблице.
	Если ЗначениеЗаполнено(ИменаПолей.Назначение) Тогда
		Если ТипЗнч(ИменаПолей.Назначение) = Тип("Структура") Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеНазначение", ИменаПолей.Назначение.ТекстПоля);
		Иначе
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеНазначение", "Коллекция." + ИменаПолей.Назначение);
		КонецЕсли;  
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеНазначение", "ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)");
	КонецЕсли; 
	// Поле статья калькуляции в большинстве случаев отсутствует в таблице.
	Если ЗначениеЗаполнено(ИменаПолей.СтатьяКалькуляции) Тогда
		Если ТипЗнч(ИменаПолей.СтатьяКалькуляции) = Тип("Структура") Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеСтатьяКалькуляции", ИменаПолей.СтатьяКалькуляции.ТекстПоля);
		Иначе
			СтрокаЗамены = """""";
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеСтатьяКалькуляции", СтрокаЗамены);
		КонецЕсли;  
	Иначе
		СтрокаЗамены = """""";
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеСтатьяКалькуляции", СтрокаЗамены);
	КонецЕсли; 
	
	// Поля серии могут быть не заданы
	СерииУказываются = ИменаПолей.Свойство("СтатусУказанияСерий") И ЗначениеЗаполнено(ИменаПолей.СтатусУказанияСерий);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеСерия", ?(СерииУказываются, "Коллекция." + ИменаПолей.Серия, "НЕОПРЕДЕЛЕНО"));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&СтатусУказанияСерий", ?(СерииУказываются, "Коллекция." + ИменаПолей.СтатусУказанияСерий, "0"));
	
	// сформируем имена полей получения склада из коллекции по типам товаров
	ИмяПоляПроизвольный = ?(ЗначениеЗаполнено(ИменаПолей.Произвольный), "Коллекция." + ИменаПолей.Произвольный, "НЕОПРЕДЕЛЕНО");
	Если ИменаПолей.Свойство("Товар") Тогда
		Если ТипЗнч(ИменаПолей.Товар) = Тип("Структура") Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеСкладТовар", ИменаПолей.Товар.ТекстПоля);
		Иначе
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеСкладТовар", ИмяПоляМестаУчета(ИменаПолей, "Товар"));
		КонецЕсли;
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеСкладТовар", ИмяПоляПроизвольный);
	КонецЕсли;
	
	Если ИменаПолей.Свойство("МногооборотнаяТара") Тогда
		Если ТипЗнч(ИменаПолей.МногооборотнаяТара) = Тип("Структура") Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеСкладМногооборотнаяТара", ИменаПолей.МногооборотнаяТара.ТекстПоля);
		Иначе
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеСкладМногооборотнаяТара", ИмяПоляМестаУчета(ИменаПолей, "МногооборотнаяТара"));
		КонецЕсли;
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеСкладМногооборотнаяТара", ИмяПоляПроизвольный);
	КонецЕсли;
	
	Если ИменаПолей.Свойство("Услуга") Тогда
		Если ТипЗнч(ИменаПолей.Услуга) = Тип("Структура") Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеСкладУслуга", ИменаПолей.Услуга.ТекстПоля);
		Иначе
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеСкладУслуга", ИмяПоляМестаУчета(ИменаПолей, "Услуга"));
		КонецЕсли;
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеСкладУслуга", ИмяПоляПроизвольный);
	КонецЕсли;
	
	Если ИменаПолей.Свойство("Работа") Тогда
		Если ТипЗнч(ИменаПолей.Работа) = Тип("Структура") Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеСкладРабота", ИменаПолей.Работа.ТекстПоля);
		Иначе
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеСкладРабота", ИмяПоляМестаУчета(ИменаПолей, "Работа"));
		КонецЕсли;
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеСкладРабота", ИмяПоляПроизвольный);
	КонецЕсли;
	
	Возврат ТекстЗапроса;
КонецФункции

Функция ТекстДополнениеКлючейАналитикиВКоллекции(ИменаПолей)
	ТекстЗапроса = "
		|ВЫБРАТЬ
		|	Коллекция.НомерСтроки - 1 КАК Индекс,
		|	&ПолеАналитика            КАК АналитикаУчетаНоменклатуры,
		|	&ПолеПриемник             КАК АналитикаУчетаНоменклатурыПриемник,
		|	&ПолеНоменклатура         КАК Номенклатура,
		|	&ПолеХарактеристика       КАК Характеристика,
		|	&ПолеСерия                КАК Серия,
		|	&ПолеВидЗапасов           КАК ВидЗапасов,
		|	&Склад                    КАК Склад
		|ПОМЕСТИТЬ ВтКоллекция
		|ИЗ &Коллекция КАК Коллекция
		|;
		|ВЫБРАТЬ
		|	Коллекция.Индекс                     КАК Индекс,
		|	Коллекция.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
		|	Коллекция.АналитикаУчетаНоменклатурыПриемник КАК АналитикаУчетаНоменклатурыПриемник,
		|	ВЫБОР КОГДА Коллекция.Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
		|		ТОГДА ЕСТЬNULL(Аналитика.Номенклатура, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка))
		|		ИНАЧЕ Коллекция.Номенклатура
		|	КОНЕЦ                                КАК Номенклатура,
		|	ВЫБОР КОГДА Коллекция.Характеристика = ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)
		|		ТОГДА ЕСТЬNULL(Аналитика.Характеристика, ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка))
		|		ИНАЧЕ Коллекция.Характеристика
		|	КОНЕЦ                                КАК Характеристика,
		|	ВЫБОР КОГДА Коллекция.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
		|		ТОГДА ЕСТЬNULL(Аналитика.Серия, ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка))
		|		ИНАЧЕ Коллекция.Серия
		|	КОНЕЦ                                КАК Серия,
		|	ВЫБОР КОГДА Коллекция.Склад В (
		|			ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка),
		|			ЗНАЧЕНИЕ(Справочник.СтруктураПредприятия.ПустаяСсылка),
		|			ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка),
		|			НЕОПРЕДЕЛЕНО)
		|			ИЛИ (Коллекция.Склад ССЫЛКА Справочник.Склады И Коллекция.Склад.ЭтоГруппа)
		|		ТОГДА Аналитика.Склад
		|		ИНАЧЕ Коллекция.Склад
		|	КОНЕЦ                                КАК Склад,
		|	Коллекция.ВидЗапасов                 КАК ВидЗапасов,
		|	&СтатьяКалькуляции                   КАК СтатьяКалькуляции
		|ПОМЕСТИТЬ Коллекция
		|ИЗ
		|	ВтКоллекция КАК Коллекция
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК Аналитика
		|	ПО Коллекция.АналитикаУчетаНоменклатуры = Аналитика.КлючАналитики
		|;
		|ВЫБРАТЬ
		|	Коллекция.Индекс КАК Индекс,
		|	Ключи.КлючАналитики КАК АналитикаУчетаНоменклатуры,
		|	Коллекция.Номенклатура КАК Номенклатура,
		|	Коллекция.Характеристика КАК Характеристика,
		|	Коллекция.Серия КАК Серия,
		|	Коллекция.Склад,
		|	СпрВидыЗапасов.УстарелоНазначение КАК Назначение,
		|	Коллекция.СтатьяКалькуляции КАК СтатьяКалькуляции
		|ИЗ
		|	Коллекция КАК Коллекция
		|
		|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыЗапасов КАК СпрВидыЗапасов
		|	ПО Коллекция.ВидЗапасов = СпрВидыЗапасов.Ссылка
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаНоменклатуры КАК Ключи
		|	ПО Ключи.Номенклатура = Коллекция.Номенклатура
		|		И Ключи.Характеристика = Коллекция.Характеристика
		|		И Ключи.Серия = Коллекция.Серия
		|		И Ключи.Склад = Коллекция.Склад
		|		И Ключи.Назначение = СпрВидыЗапасов.УстарелоНазначение
		|		И Ключи.СтатьяКалькуляции = Коллекция.СтатьяКалькуляции
		|ГДЕ
		|	Ключи.КлючАналитики ЕСТЬ NULL
		|	ИЛИ Ключи.КлючАналитики <> Коллекция.АналитикаУчетаНоменклатуры
		|	ИЛИ Коллекция.АналитикаУчетаНоменклатурыПриемник = ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаНоменклатуры.ПустаяСсылка)
		|";
	
	// заменим в тексте запроса подставляемые поля из структуры ИменаПолей
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеАналитика", "Коллекция." + ИменаПолей.АналитикаУчетаНоменклатуры);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеПриемник", "Коллекция." + ИменаПолей.ЗаполняемаяАналитикаУчетаНоменклатуры);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеНоменклатура", ?(ЗначениеЗаполнено(ИменаПолей.Номенклатура),"Коллекция." + ИменаПолей.Номенклатура, "ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)"));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеХарактеристика", ?(ЗначениеЗаполнено(ИменаПолей.Характеристика),"Коллекция." + ИменаПолей.Характеристика, "ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)"));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеСерия", ?(ЗначениеЗаполнено(ИменаПолей.Серия),"Коллекция." + ИменаПолей.Серия, "ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)"));
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПолеВидЗапасов", "Коллекция." + ИменаПолей.ВидЗапасов);
	СтрокаЗаменыСтатьяКалькуляции = """""";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&СтатьяКалькуляции", СтрокаЗаменыСтатьяКалькуляции);
	
	Возврат ТекстЗапроса;
КонецФункции

Функция ИмяПоляМестаУчета(ИменаПолей, КлючИмени, ИмяКоллекции = "Коллекция")
	Возврат
		?(ЗначениеЗаполнено(ИменаПолей[КлючИмени]),
			ИмяКоллекции + "." + ИменаПолей[КлючИмени],
			"НЕОПРЕДЕЛЕНО");
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
