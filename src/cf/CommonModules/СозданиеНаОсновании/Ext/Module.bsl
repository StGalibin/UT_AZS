﻿#Область СлужебныйПрограммныйИнтерфейс

// Список объектов, в которых используются команды создания на основании.
//
// Возвращаемое значение:
//   Массив из ОбъектМетаданных - Объекты метаданных с командами создания на основании.
//
Функция ОбъектыСКомандамиСозданияНаОсновании() Экспорт
	Массив = Новый Массив;
	СозданиеНаОснованииПереопределяемый.ПриОпределенииОбъектовСКомандамиСозданияНаОсновании(Массив);
	Возврат Массив;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ПодключаемыеКомандыПереопределяемый.ПриОпределенииСоставаНастроекПодключаемыхОбъектов.
Процедура ПриОпределенииСоставаНастроекПодключаемыхОбъектов(НастройкиПрограммногоИнтерфейса) Экспорт
	Настройка = НастройкиПрограммногоИнтерфейса.Добавить();
	Настройка.Ключ          = "ДобавитьКомандыСозданияНаОсновании";
	Настройка.ОписаниеТипов = Новый ОписаниеТипов("Булево");
КонецПроцедуры

// См. ПодключаемыеКомандыПереопределяемый.ПриОпределенииВидовПодключаемыхКоманд.
Процедура ПриОпределенииВидовПодключаемыхКоманд(ВидыПодключаемыхКоманд) Экспорт
	Вид = ВидыПодключаемыхКоманд.Добавить();
	Вид.Имя         = "СозданиеНаОсновании";
	Вид.ИмяПодменю  = "ПодменюСоздатьНаОсновании";
	Вид.Заголовок   = НСтр("ru = 'Создать на основании'");
	Вид.Порядок     = 60;
	Вид.Картинка    = БиблиотекаКартинок.ВводНаОсновании;
	Вид.Отображение = ОтображениеКнопки.Картинка;
КонецПроцедуры

// См. ПодключаемыеКомандыПереопределяемый.ПриОпределенииКомандПодключенныхКОбъекту.
Процедура ПриОпределенииКомандПодключенныхКОбъекту(НастройкиФормы, Источники, ПодключенныеОтчетыИОбработки, Команды) Экспорт
	КомандыСозданияНаОсновании = Команды.СкопироватьКолонки();
	КомандыСозданияНаОсновании.Колонки.Добавить("Обработана", Новый ОписаниеТипов("Булево"));
	КомандыСозданияНаОсновании.Индексы.Добавить("Обработана");
	
	СтандартнаяОбработка = Источники.Строки.Количество() > 0;
	СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании(КомандыСозданияНаОсновании, НастройкиФормы, СтандартнаяОбработка);
	КомандыСозданияНаОсновании.ЗаполнитьЗначения(Истина, "Обработана");
	
	ДопустимыеТипы = Новый Массив; // Типы источников, которые пользователь может изменять (см. ниже проверку права "Изменение").
	Если СтандартнаяОбработка Тогда
		ОбъектыСКомандамиСозданияНаОсновании = ОбъектыСКомандамиСозданияНаОсновании();
		Для Каждого Источник Из Источники.Строки Цикл
			Для Каждого ДокументРегистратор Из Источник.Строки Цикл
				ПодключаемыеКоманды.ДополнитьМассивТипов(ДопустимыеТипы, ДокументРегистратор.ТипСсылкиДанных);
				Если ОбъектыСКомандамиСозданияНаОсновании.Найти(ДокументРегистратор.Метаданные) <> Неопределено Тогда
					ПриДобавленииКомандСозданияНаОсновании(КомандыСозданияНаОсновании, ДокументРегистратор, НастройкиФормы);
				КонецЕсли;
			КонецЦикла;
			ПодключаемыеКоманды.ДополнитьМассивТипов(ДопустимыеТипы, Источник.ТипСсылкиДанных);
			Если ОбъектыСКомандамиСозданияНаОсновании.Найти(Источник.Метаданные) <> Неопределено Тогда
				ПриДобавленииКомандСозданияНаОсновании(КомандыСозданияНаОсновании, Источник, НастройкиФормы);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ДопустимыеТипы.Количество() = 0 Тогда
		Возврат; // Все закрыто и команд расширений с допустимыми типами тоже не будет.
	КонецЕсли;
	
	Найденные = ПодключенныеОтчетыИОбработки.НайтиСтроки(Новый Структура("ДобавитьКомандыСозданияНаОсновании", Истина));
	Для Каждого ПодключенныйОбъект Из Найденные Цикл
		ПриДобавленииКомандСозданияНаОсновании(КомандыСозданияНаОсновании, ПодключенныйОбъект, НастройкиФормы, ДопустимыеТипы);
	КонецЦикла;
	
	Для Каждого КомандаСозданияНаОсновании Из КомандыСозданияНаОсновании Цикл
		Команда = Команды.Добавить();
		ЗаполнитьЗначенияСвойств(Команда, КомандаСозданияНаОсновании);
		Команда.Вид = "СозданиеНаОсновании";
		Если Команда.Порядок = 0 Тогда
			Команда.Порядок = 50;
		КонецЕсли;
		Если Команда.РежимЗаписи = "" Тогда
			Команда.РежимЗаписи = "Записывать";
		КонецЕсли;
		Если Команда.МножественныйВыбор = Неопределено Тогда
			Команда.МножественныйВыбор = Ложь;
		КонецЕсли;
		Если Команда.ПараметрыФормы = Неопределено Тогда
			Команда.ПараметрыФормы = Новый Структура;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные для служебного программного интерфейса

Процедура ПриДобавленииКомандСозданияНаОсновании(Команды, СведенияОбОбъекте, НастройкиФормы, ДопустимыеТипы = Неопределено)
	СведенияОбОбъекте.Менеджер.ДобавитьКомандыСозданияНаОсновании(Команды, НастройкиФормы);
	ДобавленныеКоманды = Команды.НайтиСтроки(Новый Структура("Обработана", Ложь));
	Для Каждого Команда Из ДобавленныеКоманды Цикл
		Если Не ЗначениеЗаполнено(Команда.Менеджер) Тогда
			Команда.Менеджер = СведенияОбОбъекте.ПолноеИмя;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Команда.ТипПараметра) Тогда
			Команда.ТипПараметра = СведенияОбОбъекте.ТипСсылкиДанных;
		КонецЕсли;
		Если ДопустимыеТипы <> Неопределено И Не ТипВМассиве(Команда.ТипПараметра, ДопустимыеТипы) Тогда
			Команды.Удалить(Команда);
			Продолжить;
		КонецЕсли;
		Найденные = Команды.НайтиСтроки(Новый Структура("Обработана, Представление", Истина, Команда.Менеджер));
		Если Найденные.Количество() > 0 Тогда
			Найденные[0].ТипПараметра = ОбъединитьТипы(Найденные[0].ТипПараметра, Команда.ТипПараметра);
			Команды.Удалить(Команда);
			Продолжить;
		КонецЕсли;
		Команда.Обработана = Истина;
		Если Не ЗначениеЗаполнено(Команда.Обработчик) И Не ЗначениеЗаполнено(Команда.ИмяФормы) Тогда
			Команда.ИмяФормы = "ФормаОбъекта";
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Команда.ИмяПараметраФормы) Тогда
			Команда.ИмяПараметраФормы = "Основание";
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Функция ТипВМассиве(ТипИлиОписаниеТипов, МассивТипов)
	Если ТипЗнч(ТипИлиОписаниеТипов) = Тип("ОписаниеТипов") Тогда
		Для Каждого Тип Из ТипИлиОписаниеТипов.Типы() Цикл
			Если МассивТипов.Найти(Тип) <> Неопределено Тогда
				Возврат Истина;
			КонецЕсли;
		КонецЦикла;
		Возврат Ложь
	Иначе
		Возврат МассивТипов.Найти(ТипИлиОписаниеТипов) <> Неопределено;
	КонецЕсли;
КонецФункции

Функция ОбъединитьТипы(Тип1, Тип2)
	Тип1ЭтоОписаниеТипов = ТипЗнч(Тип1) = Тип("ОписаниеТипов");
	Тип2ЭтоОписаниеТипов = ТипЗнч(Тип2) = Тип("ОписаниеТипов");
	Если Тип1ЭтоОписаниеТипов И Тип1.Типы().Количество() > 0 Тогда
		ИсходноеОписаниеТипов = Тип1;
		ДобавляемыеТипы = ?(Тип2ЭтоОписаниеТипов, Тип2.Типы(), ЗначениеВМассив(Тип2));
	ИначеЕсли Тип2ЭтоОписаниеТипов И Тип2.Типы().Количество() > 0 Тогда
		ИсходноеОписаниеТипов = Тип2;
		ДобавляемыеТипы = ЗначениеВМассив(Тип1);
	ИначеЕсли ТипЗнч(Тип1) <> Тип("Тип") Тогда
		Возврат Тип2;
	ИначеЕсли ТипЗнч(Тип2) <> Тип("Тип") Тогда
		Возврат Тип1;
	Иначе
		Типы = Новый Массив;
		Типы.Добавить(Тип1);
		Типы.Добавить(Тип2);
		Возврат Новый ОписаниеТипов(Типы);
	КонецЕсли;
	Если ДобавляемыеТипы.Количество() = 0 Тогда
		Возврат ИсходноеОписаниеТипов;
	Иначе
		Возврат Новый ОписаниеТипов(ИсходноеОписаниеТипов, ДобавляемыеТипы);
	КонецЕсли;
КонецФункции

Функция ЗначениеВМассив(Значение)
	Результат = Новый Массив;
	Результат.Добавить(Значение);
	Возврат Результат;
КонецФункции

#КонецОбласти
