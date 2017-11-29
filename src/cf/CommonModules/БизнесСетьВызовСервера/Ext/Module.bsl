﻿
#Область СлужебныйПрограммныйИнтерфейс

// Получение сведений об участнике сервиса.
//
// Параметры:
//   ПараметрыКоманды - Структура, СправочникСсылка.Контрагент, СправочникСсылка.Организация - ссылка на объект поиска.
//   Результат - Структура - возвращаемые данные.
//   Отказ - Булево - признак отказа выполнения.
//
Процедура ПолучитьРеквизитыУчастника(Знач ПараметрыКоманды, Результат, Отказ) Экспорт
	
	// Если не структура, значит получена ссылка.
	Если ТипЗнч(ПараметрыКоманды) <> Тип("Структура") Тогда
		ПараметрыКоманды = Новый Структура("Ссылка, ИНН, КПП", ПараметрыКоманды);
	КонецЕсли;
	
	БизнесСеть.ВыполнитьКомандуСервиса("ПолучитьРеквизитыУчастника", ПараметрыКоманды, Результат, Отказ);
	
	// Запрос количества торговых предложений участника.
	Если Не Отказ И ТипЗнч(Результат) = Тип("Структура")
		И Результат.Свойство("Данные") И ТипЗнч(Результат.Данные) = Тип("Структура")
		И ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ТорговыеПредложения") Тогда
		
		ОбщийМодуль = ОбщегоНазначения.ОбщийМодуль("ТорговыеПредложения");
		ОтказКоличествоТорговыхПредложений = Ложь;
		КоличествоТорговыхПредложений = ОбщийМодуль.ПолучитьКоличествоТорговыхПредложений(ПараметрыКоманды,
			ОтказКоличествоТорговыхПредложений);
		Если Не ОтказКоличествоТорговыхПредложений И ТипЗнч(КоличествоТорговыхПредложений) = Тип("Число") Тогда
			Результат.Данные.Вставить("КоличествоТорговыхПредложений", КоличествоТорговыхПредложений);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Отправление приглашение контрагенту для регистрации в сервисе.
//
// Параметры:
//   Организация - СправочникСсылка - ссылка на объект организация.
//   Контрагент - СправочникСсылка - ссылка на объект контрагент.
//   ЭлектроннаяПочта - Строка - адрес электронной почты контрагента.
//   Результат - Структура - возвращаемые данные.
//   Отказ - Булево - признак отказа выполнения.
//
Процедура ОтправитьПриглашениеКонтрагенту(Организация, Контрагент, ЭлектроннаяПочта, Результат, Отказ) Экспорт
	
	ПараметрыПриглашения = Новый Структура();
	ПараметрыПриглашения.Вставить("Организация", Организация);
	ПараметрыПриглашения.Вставить("Контрагент", Контрагент);
	ПараметрыПриглашения.Вставить("ЭлектроннаяПочта", ЭлектроннаяПочта);
	
	БизнесСеть.ВыполнитьКомандуСервиса("ОтправкаПриглашения", ПараметрыПриглашения, Результат, Отказ);
	
КонецПроцедуры

// Получение списка входящих документов из сервиса.
// Параметры:
//   ПараметрыКоманды - Структура - дополнительные параметры
//     * УникальныйИдентификатор - УникальныйИдентификатор - определяет место временного хранилища.
//   Результат - Структура, Неопределено - возвращаемые данные.
//   Отказ - Булево - признак отказа выполнения.
//
Процедура ПолучитьВходящиеДокументы(ПараметрыКоманды, Результат, Отказ) Экспорт
	
	БизнесСеть.ВыполнитьКомандуСервиса("СписокВходящихДокументов", ПараметрыКоманды, Результат, Отказ);
	
КонецПроцедуры

// Удаление документов в сервисе.
//
// Параметры:
//   Организация - СправочникСсылка.Организация - организация документа.
//   МассивИдентификаторов - Массив - массив с идентификаторами ГУИД удаляемых документов.
//   Результат - Структура - возвращаемые данные.
//   Отказ - Булево - признак отказа выполнения.
//
Процедура УдалитьДокументы(ПараметрыКоманды, Результат, Отказ) Экспорт
	
	БизнесСеть.ВыполнитьКомандуСервиса("УдалитьДокументы", ПараметрыКоманды, Результат, Отказ);
	
КонецПроцедуры

// Отправка уведомлений об отправлении электронного документа.
//
// Параметры:
//   ПараметрыУдаления - Структура
//     * Организация - СправочникСсылка.Организация - организация документа.
//     * МассивИдентификаторов - Массив - массив с идентификаторами ГУИД удаляемых документов.
//   Результат - Структура - возвращаемые данные.
//   Отказ - Булево - признак отказа выполнения.
//
Процедура ОтправитьУведомлениеОбОтправке(Контрагент, МассивИдентификаторов, АдресПочты, Результат, Отказ) Экспорт
	
	ПараметрыУведомления = Новый Структура;
	ПараметрыУведомления.Вставить("Получатель", Контрагент);
	ПараметрыУведомления.Вставить("МассивИдентификаторов", МассивИдентификаторов);
	ПараметрыУведомления.Вставить("ЭлектроннаяПочта", АдресПочты);

	БизнесСеть.ВыполнитьКомандуСервиса("ОтправитьУведомлениеОбОтправке", ПараметрыУведомления, Результат, Отказ);
	
КонецПроцедуры

// Отправка документа контрагенту через сервис.
// Параметры:
//   ПараметрыКоманды - Структура - дополнительные параметры
//     * УникальныйИдентификатор - УникальныйИдентификатор - определяет место временного хранилища.
//   Результат - Структура, Неопределено - возвращаемые данные.
//   Отказ - Булево - признак отказа выполнения.
//
Процедура ОтправитьДокумент(ПараметрыКоманды, Результат, Отказ) Экспорт
	
	БизнесСеть.ВыполнитьКомандуСервиса("ОтправитьДокумент", ПараметрыКоманды, Результат, Отказ);
	
КонецПроцедуры

// Отключение организаций от сервиса.
//
// Параметры:
//  МассивОрганизаций			 - Массив - отключаемые организации.
//  РежимОтключенияВСервисе		 - Булево - Истина - отключение в сервисе, Ложь - только локально.
//  Отказ						 - Булево - Возвращает результат исполнения.
//  ТребуетсяОбновитьИнтерфейс	 - Булево - Возвращает Истина, если после исполнения требуется обновления интерфейса.
//
Процедура ОтключитьОрганизации(МассивОрганизаций, РежимОтключенияВСервисе, Отказ, ТребуетсяОбновитьИнтерфейс) Экспорт
	
	БизнесСеть.ОтключитьОрганизации(МассивОрганизаций, РежимОтключенияВСервисе, Отказ, ТребуетсяОбновитьИнтерфейс);
	
КонецПроцедуры

// Обновление пользователей в сервисе по данным информационной базы.
//
// Параметры:
//   ТекущийАбонент - Строка - идентификатор абонента в сервисе.
//   ОбновлятьИдентификаторыДоступа - Булево.
//   Результат - Произвольный - результат выполнения.
//   Отказ - Булево - признак ошибки выполнения.
//
Процедура ОбновитьПользователейВСервисе(ТекущийАбонент, ОбновлятьИдентификаторыДоступа, Результат, Отказ) Экспорт
	
	БизнесСеть.ОбновитьПользователейВСервисе(ТекущийАбонент, ОбновлятьИдентификаторыДоступа, Результат, Отказ);

КонецПроцедуры

// Получение данных электронного документа в сервисе.
//
Функция ПолучитьДанныеДокументаСервиса(МассивИдентификаторов, ЭтоРежимЗагрузки, УникальныйИдентификатор, ЗагрузкаПредставления = Ложь) Экспорт
	
	ПараметрыКоманды = Новый Структура();
	ПараметрыКоманды.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	Результат = Неопределено;
	
	ПараметрыКоманды.Вставить("МассивСсылокНаОбъект", МассивИдентификаторов);
	ПараметрыКоманды.Вставить("РежимВходящихДокументов", ЭтоРежимЗагрузки);
	ПараметрыКоманды.Вставить("withData", "true");
	
	Отказ = Ложь;
	БизнесСеть.ВыполнитьКомандуСервиса("ПолучитьДокументы", ПараметрыКоманды, Результат, Отказ);
	Если Отказ ИЛИ Результат.КодСостояния <> 200 Тогда
		ВидОперации = НСтр("ru = 'Получение документов.'");
		ТекстСообщения = НСтр("ru = 'Ошибка получения документов.'");
		ПодробныйТекстОшибки = "";
		Если Результат.Свойство("Данные") И ТипЗнч(Результат.Данные) = Тип("Структура") И Результат.Данные.Свойство("message") Тогда
			ПодробныйТекстОшибки = СтрШаблон(НСтр("ru = 'Код состояния %1. %2'"), Результат.КодСостояния, Результат.Данные.message);
		КонецЕсли;
		ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОбработатьОшибку(ВидОперации, ПодробныйТекстОшибки, ТекстСообщения, "БизнесСеть");
		Возврат Неопределено;
	КонецЕсли;

	Если Не ЗагрузкаПредставления Тогда // Открытие документов представления.
		МассивАдресовДанных = КонвертацияДанныхВХранилищеBase64(Результат.Данные, "documentData", УникальныйИдентификатор);
	Иначе
		МассивАдресовДанных = КонвертацияДанныхВХранилищеBase64(Результат.Данные, "documentPresentationData", УникальныйИдентификатор);
	КонецЕсли;
	
	Возврат МассивАдресовДанных;
	
КонецФункции

// Получение массива организаций, зарегистрированных в сервисе.
//
// Возвращаемое значение:
//   Массив - зарегистрированные организации в сервисе.
//
Функция МассивЗарегистрированныхОрганизаций() Экспорт

	Запрос = Новый Запрос;
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка КАК Ссылка
	|ИЗ
	|	РегистрСведений.Организации1СБизнесСеть КАК Организации1СБизнесСеть
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник_Организации КАК Организации
	|		ПО Организации1СБизнесСеть.Организация = Организации.Ссылка
	|ГДЕ
	|	НЕ Организации.Ссылка ЕСТЬ NULL
	|	И НЕ Организации1СБизнесСеть.Организация.ПометкаУдаления";

	ИмяСправочникаОрганизации = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяПрикладногоСправочника("Организации");
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "Справочник_Организации", "Справочник." + ИмяСправочникаОрганизации);
	Запрос.Текст = ТекстЗапроса;
	Результат = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат Результат;
	
КонецФункции

// Формирование документа ИБ по электронному документу.
//
// Параметры:
//   ПараметрыФормирования - Структура - структура данных формирования.
//   ДокументСсылка - ДокументСсылка - документ информационной базы.
//   ТекстСообщения - Строка - текст при возникновении ошибки.
//   Записывать - Булево - записывать документ.
//   Отказ - Булево - результат выполнения.
//
Процедура СформироватьДокументИБ(ПараметрыФормирования, ДокументСсылка, ТекстСообщения, Записывать = Ложь,
	ОбновитьСтруктуруРазбора = Ложь, Отказ = Ложь) Экспорт
	
	БизнесСеть.СформироватьДокументИБ(ПараметрыФормирования, ДокументСсылка, ТекстСообщения, Записывать,
		ОбновитьСтруктуруРазбора, Отказ);
	
КонецПроцедуры

// Проверка возможности отправки документа.
//
// Параметры:
//  Ссылка		 - ДокументСсылка - ссылка на отправляемый документ.
//  Организация	 - ОпределяемыйТип.Организация - заполняется в функции, в случае если ИБ не зарегистрирована,
//                                               требуется для дальнейшей регистрации организации.
// 
// Возвращаемое значение:
//  Булево - результат проверки.
//
Функция ВозможнаОтправкаДокумента(МассивСсылок, Организация, ТекстОшибки, Отказ) Экспорт
	
	Если МассивСсылок.Количество() > 1 Тогда
		// Проверка совпадения отправителя и получателя в документах.
		БизнесСетьПереопределяемый.ВыполнитьКонтрольРеквизитовДокументов(МассивСсылок, ТекстОшибки, Отказ);
		Если Отказ Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Отклонить документы.
//
// Параметры:
//  ПараметрыВызова - Структура, Массив - данные для отклонения, для массива элементами является структура.
//    * Ссылка - ДокументСсылка - ссылка документа информационной базы.
//    * Идентификатор - Число - идентификатор документа сервиса.
//  Отказ			 - Булево - возвращает результат исполнения.
//
Процедура ОтклонитьДокументы(ПараметрыВызова, Отказ) Экспорт 
	
	Если ТипЗнч(ПараметрыВызова) = Тип("Массив") Тогда
		МассивДанных = ПараметрыВызова;
	ИначеЕсли ТипЗнч(ПараметрыВызова) = Тип("Структура") Тогда
		МассивДанных = Новый Массив;
		МассивДанных.Добавить(ПараметрыВызова);
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Ошибка параметров команды отклонения'"),,,, Отказ);
	КонецЕсли;
	
	ДопПараметры = Новый Структура();
	ДопПараметры.Вставить("МассивДанных", МассивДанных);
	ДопПараметры.Вставить("Статус", "Отклонен");
	
	Результат = Неопределено;
	БизнесСеть.ВыполнитьКомандуСервиса("ИзменитьСтатусыДокументов", ДопПараметры, Результат, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Преобразование данных документа сервиса во временном хранилище из Base64.
//
// Параметры:
//   МассивДокументов - Массив - электронные документы, тип Структура.
//   ИмяСвойства - Строка - наименование свойства.
//   УникальныйИдентификатор - УникальныйИдентификатор, Строка - идентификатор для сохранения хранилища.
//
// Возвращаемое значение:
//   Массив - список адресов временного хранилища с конвертированными данными.
//
Функция КонвертацияДанныхВХранилищеBase64(МассивДокументов, ИмяСвойства, УникальныйИдентификатор)
	
	МассивВозврата = Новый Массив();
	Для каждого ЭлементМассива Из МассивДокументов Цикл
		ДанныеДокумента = ЭлементМассива[ИмяСвойства];
		МассивВозврата.Добавить(ПоместитьВоВременноеХранилище(Base64Значение(ДанныеДокумента), УникальныйИдентификатор));
	КонецЦикла;
	
	Возврат МассивВозврата;
	
КонецФункции

#КонецОбласти
