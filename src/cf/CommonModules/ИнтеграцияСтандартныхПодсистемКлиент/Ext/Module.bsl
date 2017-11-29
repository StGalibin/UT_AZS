﻿////////////////////////////////////////////////////////////////////////////////
// Интеграция подсистем библиотеки друг с другом.
// Здесь размещена обработка программных событий, возникающих в подсистемах-источниках,
// в тех случаях, когда подсистем-приемников более одной или их список заранее неизвестен.
//

#Область СлужебныйПрограммныйИнтерфейс

#Область БазоваяФункциональность

// См. ОбщегоНазначенияКлиентПереопределяемый.ПередНачаломРаботыСистемы.
Процедура ПередНачаломРаботыСистемы(Параметры) Экспорт
	
	// Начало замера времени запуска программы.
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности") Тогда
		МодульОценкаПроизводительностиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОценкаПроизводительностиКлиент");
		Параметры.Модули.Добавить(МодульОценкаПроизводительностиКлиент);
	КонецЕсли;
	
	// Проверка минимальных прав на вход в программу.
	Параметры.Модули.Добавить(ПользователиСлужебныйКлиент);
	
	// Проверка блокировки информационной базы для обновления.
	Параметры.Модули.Добавить(ОбновлениеИнформационнойБазыКлиент);
	
	// Проверка минимально допустимой версии платформы для запуска.
	Параметры.Модули.Добавить(Новый Структура("Модуль, Номер", СтандартныеПодсистемыКлиент, 2));
	
	// Проверка необходимости восстановления связи с главным узлом.
	Параметры.Модули.Добавить(Новый Структура("Модуль, Номер", СтандартныеПодсистемыКлиент, 3));
	
	// Проверка блокировки области данных для обслуживания.
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса") Тогда
		МодульРаботаВМоделиСервисаКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаВМоделиСервисаКлиент");
		Параметры.Модули.Добавить(МодульРаботаВМоделиСервисаКлиент);
	КонецЕсли;
	
	// Подтверждение легальности перед началом обновления ИБ.
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует(
		   "СтандартныеПодсистемы.ПроверкаЛегальностиПолученияОбновления") Тогда
		
		МодульПроверкаЛегальностиПолученияОбновленияКлиент =
			ОбщегоНазначенияКлиент.ОбщийМодуль("ПроверкаЛегальностиПолученияОбновленияКлиент");
		
		Параметры.Модули.Добавить(МодульПроверкаЛегальностиПолученияОбновленияКлиент);
	КонецЕсли;
	
	// Запрос у пользователя продолжения с повтором или без повтора загрузки сообщения обмена данными.
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными") Тогда
		МодульОбменДаннымиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменДаннымиКлиент");
		Параметры.Модули.Добавить(МодульОбменДаннымиКлиент);
	КонецЕсли;
	
	// Проверка статуса обработчиков отложенного обновления.
	Параметры.Модули.Добавить(Новый Структура("Модуль, Номер", ОбновлениеИнформационнойБазыКлиент, 2));
	
	// Загрузка/обновление параметров работы программы.
	Параметры.Модули.Добавить(Новый Структура("Модуль, Номер", ОбновлениеИнформационнойБазыКлиент, 3));
	
	// Настройка автономного рабочего места при первом запуске.
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует(
	       "ТехнологияСервиса.РаботаВМоделиСервиса.ОбменДаннымиВМоделиСервиса") Тогда
		
		МодульАвтономнаяРаботаСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("АвтономнаяРаботаСлужебныйКлиент");
		Параметры.Модули.Добавить(МодульАвтономнаяРаботаСлужебныйКлиент);
	КонецЕсли;
	
	// Проверка авторизации пользователя.
	Параметры.Модули.Добавить(Новый Структура("Модуль, Номер", ПользователиСлужебныйКлиент, 2));
	
	// Проверка блокировки входа в информационную базу.
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЗавершениеРаботыПользователей") Тогда
		МодульСоединенияИБКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СоединенияИБКлиент");
		Параметры.Модули.Добавить(МодульСоединенияИБКлиент);
	КонецЕсли;
	
	// Обновление информационной базы.
	Параметры.Модули.Добавить(Новый Структура("Модуль, Номер", ОбновлениеИнформационнойБазыКлиент, 4));
	
	// Обработка ключа запуска ВыполнитьОбновлениеИЗавершитьРаботу.
	Параметры.Модули.Добавить(Новый Структура("Модуль, Номер", ОбновлениеИнформационнойБазыКлиент, 5));
	
	// Смена пароля при входе, если требуется.
	Параметры.Модули.Добавить(Новый Структура("Модуль, Номер", ПользователиСлужебныйКлиент, 3));
	
КонецПроцедуры

// См. ОбщегоНазначенияКлиентПереопределяемый.ПриНачалеРаботыСистемы.
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	// Открытие помощника настройки подчиненного узла РИБ при первом запуске.
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными") Тогда
		МодульОбменДаннымиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменДаннымиКлиент");
		Параметры.Модули.Добавить(МодульОбменДаннымиКлиент);
	КонецЕсли;
	
	// Открытие описания изменений системы.
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОбновлениеВерсииИБ") Тогда
		МодульОбновлениеИнформационнойБазыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбновлениеИнформационнойБазыКлиент");
		Параметры.Модули.Добавить(МодульОбновлениеИнформационнойБазыКлиент);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОбновлениеКонфигурации") Тогда
		МодульОбновлениеКонфигурацииКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбновлениеКонфигурацииКлиент");
		Параметры.Модули.Добавить(МодульОбновлениеКонфигурацииКлиент);
	КонецЕсли;
	
	// Показывает форму блокировки работы с внешними ресурсами, если нужно.
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РегламентныеЗадания") Тогда
		МодульРегламентныеЗаданияКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РегламентныеЗаданияКлиент");
		Параметры.Модули.Добавить(МодульРегламентныеЗаданияКлиент);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РезервноеКопированиеИБ") Тогда
		МодульРезервноеКопированиеИБКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РезервноеКопированиеИБКлиент");
		Параметры.Модули.Добавить(МодульРезервноеКопированиеИБКлиент);
    КонецЕсли;
    
    Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЦентрМониторинга") Тогда
        МодульЦентрМониторингаКлиентСлужебный = ОбщегоНазначенияКлиент.ОбщийМодуль("ЦентрМониторингаКлиентСлужебный");
        Параметры.Модули.Добавить(МодульЦентрМониторингаКлиентСлужебный);
    КонецЕсли;
	
	ИнтеграцияСТехнологиейСервисаКлиент.ПриНачалеРаботыСистемы(Параметры);
	
КонецПроцедуры

// См. ОбщегоНазначенияКлиентПереопределяемый.ПослеНачалаРаботыСистемы.
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	СтандартныеПодсистемыКлиент.ПослеНачалаРаботыСистемы();
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Банки") Тогда
		МодульРаботаСБанкамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСБанкамиКлиент");
		МодульРаботаСБанкамиКлиент.ПослеНачалаРаботыСистемы();
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Валюты") Тогда
		МодульРаботаСКурсамиВалютКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСКурсамиВалютКлиент");
		МодульРаботаСКурсамиВалютКлиент.ПослеНачалаРаботыСистемы();
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЗавершениеРаботыПользователей") Тогда
		МодульСоединенияИБКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СоединенияИБКлиент");
		МодульСоединенияИБКлиент.ПослеНачалаРаботыСистемы();
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ИнформацияПриЗапуске") Тогда
		МодульИнформацияПриЗапускеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнформацияПриЗапускеКлиент");
		МодульИнформацияПриЗапускеКлиент.ПослеНачалаРаботыСистемы();
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.НапоминанияПользователя") Тогда
		МодульНапоминанияПользователяКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("НапоминанияПользователяКлиент");
		МодульНапоминанияПользователяКлиент.ПослеНачалаРаботыСистемы();
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОбменДанными") Тогда
		МодульОбменДаннымиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменДаннымиКлиент");
		МодульОбменДаннымиКлиент.ПослеНачалаРаботыСистемы();
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыКлиент.ПослеНачалаРаботыСистемы();
	ПользователиСлужебныйКлиент.ПослеНачалаРаботыСистемы();
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПрофилиБезопасности") Тогда
		МодульНастройкаРазрешенийНаИспользованиеВнешнихРесурсовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("НастройкаРазрешенийНаИспользованиеВнешнихРесурсовКлиент");
		МодульНастройкаРазрешенийНаИспользованиеВнешнихРесурсовКлиент.ПослеНачалаРаботыСистемы();
	КонецЕсли;
	
КонецПроцедуры

// См. ОбщегоНазначенияКлиентПереопределяемый.ПриОбработкеПараметровЗапуска.
Процедура ПриОбработкеПараметровЗапуска(ПараметрыЗапуска, Отказ) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ЗавершениеРаботыПользователей") Тогда
		МодульСоединенияИБКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СоединенияИБКлиент");
		МодульСоединенияИБКлиент.ПриОбработкеПараметровЗапуска(ПараметрыЗапуска, Отказ);
	КонецЕсли;
	
КонецПроцедуры

// См. ОбщегоНазначенияКлиентПереопределяемый.ПередЗавершениемРаботыСистемы.
Процедура ПередЗавершениемРаботыСистемы(Отказ, Предупреждения) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОбновлениеКонфигурации") Тогда
		МодульОбновлениеКонфигурацииКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбновлениеКонфигурацииКлиент");
		МодульОбновлениеКонфигурацииКлиент.ПередЗавершениемРаботыСистемы(Отказ, Предупреждения);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайламиСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСФайламиСлужебныйКлиент");
		МодульРаботаСФайламиСлужебныйКлиент.ПередЗавершениемРаботыСистемы(Отказ, Предупреждения);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РезервноеКопированиеИБ") Тогда
		МодульРезервноеКопированиеИБКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РезервноеКопированиеИБКлиент");
		МодульРезервноеКопированиеИБКлиент.ПередЗавершениемРаботыСистемы(Отказ, Предупреждения);
	КонецЕсли;
	
	ИнтеграцияСТехнологиейСервисаКлиент.ПередЗавершениемРаботыСистемы(Отказ, Предупреждения);
	
КонецПроцедуры

#КонецОбласти

#Область РезервноеКопированиеИБ

// Проверяет возможность выполнения резервного копирования в пользовательском режиме.
//
// Параметры:
//  Результат - Булево (возвращаемое значение).
//
Процедура ПриПроверкеВозможностиРезервногоКопированияВПользовательскомРежиме(Результат) Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ТехнологияСервиса.РезервноеКопированиеИБ") Тогда
		МодульРезервноеКопированиеИБКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РезервноеКопированиеИБКлиент");
		МодульРезервноеКопированиеИБКлиент.ПриПроверкеВозможностиРезервногоКопированияВПользовательскомРежиме(Результат);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ТехнологияСервиса.РезервноеКопированиеОбластейДанных") Тогда
		МодульРезервноеКопированиеОбластейДанныхКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РезервноеКопированиеОбластейДанныхКлиент");
		МодульРезервноеКопированиеОбластейДанныхКлиент.ПриПроверкеВозможностиРезервногоКопированияВПользовательскомРежиме(Результат);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при предложении создать резервную копию.
Процедура ПриПредложенииПользователюСоздатьРезервнуюКопию() Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ТехнологияСервиса.РезервноеКопированиеИБ") Тогда
		МодульРезервноеКопированиеИБКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РезервноеКопированиеИБКлиент");
		МодульРезервноеКопированиеИБКлиент.ПриПредложенииПользователюСоздатьРезервнуюКопию();
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ТехнологияСервиса.РезервноеКопированиеОбластейДанных") Тогда
		МодульРезервноеКопированиеОбластейДанныхКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РезервноеКопированиеОбластейДанныхКлиент");
		МодульРезервноеКопированиеОбластейДанныхКлиент.ПриПредложенииПользователюСоздатьРезервнуюКопию();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
