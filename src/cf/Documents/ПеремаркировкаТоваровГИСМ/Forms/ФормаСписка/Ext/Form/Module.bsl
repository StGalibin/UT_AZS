﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	//++ НЕ ГИСМ
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	//-- НЕ ГИСМ
	
	Элементы.ОрганизацияОтбор.Видимость = ИнтеграцияГИСМ.ИспользоватьНесколькоОрганизаций();
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);

	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "СтатусГИСМ", СтатусГИСМ, СтруктураБыстрогоОтбора);
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Ответственный", Ответственный, СтруктураБыстрогоОтбора);
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Организация", Организация, СтруктураБыстрогоОтбора);
	
	Если ИнтеграцияГИСМКлиентСервер.НеобходимОтборПоДальнейшемуДействиюГИСМПриСозданииНаСервере(ДальнейшееДействиеГИСМ, СтруктураБыстрогоОтбора) Тогда
		УстановитьОтборПоДальнейшемуДействиюСервер();
	КонецЕсли;
	
	ИнтеграцияГИСМ.ЗаполнитьСписокВыбораДальнейшееДействие(
		Элементы.ДальнейшееДействиеГИСМОтбор.СписокВыбора,
		ВсеТребующиеДействия(),
		ВсеТребующиеОжидания());
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                     "СтатусГИСМ",
	                                                                     СтатусГИСМ,
	                                                                     СтруктураБыстрогоОтбора,
	                                                                     Настройки);
	
	Если ИнтеграцияГИСМКлиентСервер.НеобходимОтборПоДальнейшемуДействиюГИСМПередЗагрузкойИзНастроек(ДальнейшееДействиеГИСМ, СтруктураБыстрогоОтбора, Настройки) Тогда
		УстановитьОтборПоДальнейшемуДействиюСервер();
	КонецЕсли;
	
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                     "Ответственный",
	                                                                     Ответственный,
	                                                                     СтруктураБыстрогоОтбора,
	                                                                     Настройки);
	
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                     "Склад",
	                                                                     Склад,
	                                                                     СтруктураБыстрогоОтбора,
	                                                                     Настройки);
	
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                     "Организация",
	                                                                     Организация,
	                                                                     СтруктураБыстрогоОтбора,
	                                                                     Настройки);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	//++ НЕ ГИСМ
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	//-- НЕ ГИСМ
	
	Если ИмяСобытия = "ИзменениеСостоянияГИСМ"
		И ТипЗнч(Параметр.Ссылка) = Тип("ДокументСсылка.ПеремаркировкаТоваровГИСМ") Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ВыполненОбменГИСМ"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусГИСМФормахВДокументах)) Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтатусГИСМОтборПриИзменении(Элемент)
	УстановитьОтборПоСтатусуГИСМСервер();
КонецПроцедуры

&НаКлиенте
Процедура ДальнейшееДействиеГИСМОтборПриИзменении(Элемент)
	УстановитьОтборПоДальнейшемуДействиюСервер();
КонецПроцедуры

&НаКлиенте
Процедура СкладБыстрыйОтборПриИзменении(Элемент)
	УстановитьОтборПоСкладуСервер();
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйОтборПриИзменении(Элемент)
	УстановитьОтборПоОтветственномуСервер();
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
	                                                                        "Организация",
	                                                                        Организация,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(Организация));
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.ДальнейшееДействиеГИСМ Тогда
		
		СтандартнаяОбработка = Ложь;
		ТекущиеДанные = Элемент.ДанныеСтроки(ВыбраннаяСтрока);
		
		ИнтеграцияГИСМКлиент.ВыполнитьДальнейшееДействиеДляДокументовИзСписка(
			Элементы.Список,
			Элемент.ДанныеСтроки(ВыбраннаяСтрока).ДальнейшееДействиеГИСМ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

//++ НЕ ГИСМ

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

//-- НЕ ГИСМ

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ПередатьДанныеОМаркировкеТоваров(Команда)
	
	ИнтеграцияГИСМКлиент.ВыполнитьДальнейшееДействиеДляДокументовИзСписка(
		Элементы.Список,
		ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеМаркировкаТоваров"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПередатьДанныеОПеремаркировкеТоваров(Команда)
	
	ИнтеграцияГИСМКлиент.ВыполнитьДальнейшееДействиеДляДокументовИзСписка(
		Элементы.Список,
		ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеПеремаркировкаТоваров"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПередатьДанныеСписаниеКиЗ(Команда)
	
	ИнтеграцияГИСМКлиент.ВыполнитьДальнейшееДействиеДляДокументовИзСписка(
		Элементы.Список,
		ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеСписаниеКиЗ"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	ИнтеграцияГИСМКлиент.ВыполнитьОбмен();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	СписокУсловноеОформление = Список.КомпоновщикНастроек.Настройки.УсловноеОформление;
	СписокУсловноеОформление.Элементы.Очистить();
	
	ИнтеграцияГИСМ.УстановитьУсловноеОформлениеСтатусДальнейшееДействиеГИСМ(
		УсловноеОформление,
		Элементы,
		Элементы.СтатусГИСМ.Имя,
		Элементы.ДальнейшееДействиеГИСМ.Имя,
		"Список.СтатусГИСМ",
		"Список.ДальнейшееДействиеГИСМ");
		
	ИнтеграцияГИСМ.УстановитьУсловноеОформлениеСтатусИнформированияГИСМ(
		УсловноеОформление,
		Элементы,
		Элементы.СтатусГИСМ.Имя,
		"Список.СтатусГИСМ");
	
	ИнтеграцияГИСМ.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список", "Дата");
	
КонецПроцедуры

//++ НЕ ГИСМ

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция ПолучитьСсылкуНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.МаркировкаТоваровГИСМ.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = ПолучитьСсылкуНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Элементы.Список.ТекущаяСтрока = МассивСсылок[0];
		ПоказатьЗначение(Неопределено, МассивСсылок[0]);
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

//-- НЕ ГИСМ

#Область ОтборыСписка

&НаСервере
Процедура УстановитьОтборПоОтветственномуСервер(СохранятьОтбор = Истина)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Ответственный",
		Ответственный,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Ответственный));
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоСкладуСервер(СохранятьОтбор = Истина)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Склад",
		Склад,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Склад)); 
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоСтатусуГИСМСервер(СохранятьОтбор = Истина)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"СтатусГИСМ",
		СтатусГИСМ,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(СтатусГИСМ));
		
КонецПроцедуры

#Область ОтборДальнейшиеДействия

&НаСервереБезКонтекста
Функция ВсеТребующиеДействия()
	
	МассивДействий = Новый Массив();
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные);
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеСписаниеКиЗ);
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеМаркировкаТоваров);
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанныеПеремаркировкаТоваров);
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическуюОтправкуПолучениеДанныхГИСМ") Тогда
		МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ВыполнитеОбмен);
	КонецЕсли;
	
	Возврат МассивДействий;
	
КонецФункции

&НаСервереБезКонтекста
Функция ВсеТребующиеОжидания()
	
	МассивДействий = Новый Массив();
	Если ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическуюОтправкуПолучениеДанныхГИСМ") Тогда
		МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПередачуДанныхРегламентнымЗаданием);
	КонецЕсли;
	МассивДействий.Добавить(Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПолучениеКвитанцииОФиксации);
	
	Возврат МассивДействий
	
КонецФункции

&НаСервере
Процедура УстановитьОтборПоДальнейшемуДействиюСервер()
	
	ИнтеграцияГИСМ.УстановитьОтборПоДальнейшемуДействию(Список,
	                                                    ДальнейшееДействиеГИСМ,
	                                                    ВсеТребующиеДействия(),
	                                                    ВсеТребующиеОжидания());
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти
