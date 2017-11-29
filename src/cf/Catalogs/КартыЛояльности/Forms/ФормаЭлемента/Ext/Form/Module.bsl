﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	// Обработчик подсистемы "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	// подсистема запрета редактирования ключевых реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	ТекущаяДата = ТекущаяДатаСеанса();
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) И ЗначениеЗаполнено(Объект.Владелец) Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ВидыКартЛояльности.Статус,
		|	ВидыКартЛояльности.ДатаНачалаДействия,
		|	ВидыКартЛояльности.ДатаОкончанияДействия,
		|	ВидыКартЛояльности.ТипКарты
		|ИЗ
		|	Справочник.ВидыКартЛояльности КАК ВидыКартЛояльности
		|ГДЕ
		|	ВидыКартЛояльности.Ссылка = &Ссылка");
		
		Запрос.УстановитьПараметр("Ссылка", Объект.Владелец);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		Если ЗначениеЗаполнено(Выборка.ДатаОкончанияДействия) И НачалоДня(ТекущаяДата) > Выборка.ДатаОкончанияДействия Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Срок действия карт лояльности ""%1"" истек.'"), Объект.Владелец);
		КонецЕсли;
		Если Выборка.Статус = Перечисления.СтатусыВидовКартЛояльности.Закрыт Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Карты лояльности ""%1"" закрыты.'"), Объект.Владелец);
		КонецЕсли;
		
	КонецЕсли;
	
	ПриВыбореВидаКартыЛояльности();
	СформироватьАвтонаименование(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

	ЗаполнитьИнформациюОПартнере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьПодключениеОборудованиеПриОткрытииФормы(ЭтаФорма, "СканерШтрихкода,СчитывательМагнитныхКарт");
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиентПереопределяемый.НачатьОтключениеОборудованиеПриЗакрытииФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияКлиентПереопределяемый.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияКлиент.ПреобразоватьДанныеСоСканераВМассив(Параметр));
		ИначеЕсли ИмяСобытия ="TracksData" Тогда
			ОбработатьДанныеСчитывателяМагнитныхКарт(Параметр);
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец Свойства

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// подсистема запрета редактирования ключевых реквизитов объектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ПартнерПриИзменении(Элемент)
	
	ЗаполнитьИнформациюОПартнере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	ПриВыбореВидаКартыЛояльности();
	СформироватьАвтонаименование(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СоглашениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ПараметрыВыбораСоглашения = ПродажиКлиент.ПараметрыНачалаВыбораСоглашенияСКлиентом();
	
	ПараметрыВыбораСоглашения.Элемент               = Элемент;
	ПараметрыВыбораСоглашения.Партнер               = Объект.Партнер;
	ПараметрыВыбораСоглашения.Документ              = Объект.Соглашение;
	ПараметрыВыбораСоглашения.ДатаДокумента         = ТекущаяДата;
	ПараметрыВыбораСоглашения.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.РеализацияКлиенту");
	ПараметрыВыбораСоглашения.ДанныеФормыСтруктура  = Объект;
	
	ПродажиКлиент.НачалоВыбораСоглашенияСКлиентом(ПараметрыВыбораСоглашения, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриВыбореВидаКартыЛояльности()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВидыКартЛояльности.Статус,
	|	ВидыКартЛояльности.ДатаНачалаДействия,
	|	ВидыКартЛояльности.ДатаОкончанияДействия,
	|	ВидыКартЛояльности.Персонализирована,
	|	ВидыКартЛояльности.ТипКарты
	|ИЗ
	|	Справочник.ВидыКартЛояльности КАК ВидыКартЛояльности
	|ГДЕ
	|	ВидыКартЛояльности.Ссылка = &Ссылка");
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Владелец);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Если Выборка.Следующий() Тогда
	
		ТипКарты = Выборка.ТипКарты;
		
		Элементы.Штрихкод.Видимость = (ТипКарты = Перечисления.ТипыКарт.Штриховая ИЛИ ТипКарты = Перечисления.ТипыКарт.Смешанная);
		Элементы.МагнитныйКод.Видимость = (ТипКарты = Перечисления.ТипыКарт.Магнитная ИЛИ ТипКарты = Перечисления.ТипыКарт.Смешанная);
		Элементы.ГруппаВладелец.Видимость = Выборка.Персонализирована;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьДанныеПартнераИЗакрытьФорму(Команда)
	
	ЗаписатьДанныеПартнераНаСервере();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтаФорма);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

#Область ШтрихкодыИТорговоеОборудование

// МеханизмВнешнегоОборудования
&НаКлиенте
Процедура ОбработатьШтрихкоды(ДанныеШтрихкода)
	
	Объект.Штрихкод = ДанныеШтрихкода[0].Штрихкод;
	
КонецПроцедуры
// Конец МеханизмВнешнегоОборудования

&НаКлиенте
Процедура ОбработатьДанныеСчитывателяМагнитныхКарт(Данные)
	
	СписокКодов = Новый СписокЗначений;
	
	РасшифрованныеДанные = Данные[1][3];
	Если РасшифрованныеДанные <> Неопределено Тогда
		Для Каждого Структура Из РасшифрованныеДанные Цикл
			
			ШаблонМагнитнойКарты = Структура.Шаблон;
			КодКарты             = Неопределено;
			Для Каждого ДанныеПоля Из Структура.ДанныеДорожек Цикл
				Если ДанныеПоля.Поле = ПредопределенноеЗначение("Перечисление.ПоляШаблоновМагнитныхКарт.Код") Тогда
					СписокКодов.Добавить(ДанныеПоля.ЗначениеПоля);
				КонецЕсли;
			КонецЦикла;
			
		КонецЦикла;
	КонецЕсли;
	
	Если СписокКодов.Количество() = 1 Тогда
		Объект.МагнитныйКод = СписокКодов.Получить(0).Значение;
	ИначеЕсли СписокКодов.Количество() = 0 Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Код карты %1 не соответствует ни одному из шаблонов магнитных карт.'"));
	Иначе
		ВыбранноеЗначение = Неопределено;

		СписокКодов.ПоказатьВыборЭлемента(Новый ОписаниеОповещения("ОбработатьДанныеСчитывателяМагнитныхКартЗавершение", ЭтотОбъект), НСтр("ru = 'Выбор кода магнитной карты'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьДанныеСчитывателяМагнитныхКартЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
    
    ВыбранноеЗначение = ВыбранныйЭлемент;
    Если ВыбранноеЗначение <> Неопределено Тогда
        Объект.МагнитныйКод = ВыбранноеЗначение.Значение;
    КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ШтрихкодПриИзменении(Элемент)
	СформироватьАвтонаименование(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура МагнитныйКодПриИзменении(Элемент)
	СформироватьАвтонаименование(ЭтаФорма);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СформироватьАвтонаименование(Форма)
	
	Наименование = Строка(Форма.Объект.Владелец)
	               + ?(ЗначениеЗаполнено(Форма.Объект.Штрихкод), " " + Строка(Форма.Объект.Штрихкод), "")
	               + ?(ЗначениеЗаполнено(Форма.Объект.МагнитныйКод), " " + Строка(Форма.Объект.МагнитныйКод), "");
	
	Форма.Элементы.Наименование.СписокВыбора.Очистить();
	Форма.Элементы.Наименование.СписокВыбора.Добавить(Наименование);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьДанныеПартнераНаСервере()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПартнерОбъект = Объект.Партнер.ПолучитьОбъект();
	ПартнерОбъект.НаименованиеПолное              = ФИОПартнера;
	ПартнерОбъект.Пол                             = ПолПартнера;
	ПартнерОбъект.ДатаРождения                    = ДатаРожденияПартнера;
	ПартнерОбъект.ВариантОтправкиЭлектронногоЧека = ВариантОтправкиЭлектронногоЧека;
	ПартнерОбъект.Записать();
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИнформациюОПартнере()
	
	ДанныеКартыЛояльности = КартыЛояльностиВызовСервера.ПолучитьДанныеКартыЛояльности(Объект.Ссылка, Истина);
	
	Элементы.Партнер.Видимость    = ДанныеКартыЛояльности.ПартнерДоступен;
	Элементы.Контрагент.Видимость =  ДанныеКартыЛояльности.КонтрагентДоступен;
	Элементы.Соглашение.Видимость =  ДанныеКартыЛояльности.СоглашениеДоступно;
	
	УстановитьПривилегированныйРежим(Истина);
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Партнер,"ДатаРождения,Пол,ЮрФизЛицо,НаименованиеПолное,ВариантОтправкиЭлектронногоЧека");
	УстановитьПривилегированныйРежим(Ложь);
	
	ПолПартнера                     = ЗначенияРеквизитов.Пол;
	ДатаРожденияПартнера            = ЗначенияРеквизитов.ДатаРождения;
	ФИОПартнера                     = ЗначенияРеквизитов.НаименованиеПолное;
	ВариантОтправкиЭлектронногоЧека = ЗначенияРеквизитов.ВариантОтправкиЭлектронногоЧека;
	
	ОтображатьДанныеПартнера =
		ЗначениеЗаполнено(Объект.Партнер)
		И (ЗначенияРеквизитов.ЮрФизЛицо = Перечисления.КомпанияЧастноеЛицо.ЧастноеЛицо);
		
	Элементы.ГруппаДанныеПартнераФизическогоЛица.Видимость = ОтображатьДанныеПартнера;
	Если ОтображатьДанныеПартнера Тогда
		
		ПраваДоступаРМК = НастройкиПродажДляПользователейСервер.ПраваДоступаРМК(Пользователи.ТекущийПользователь());
		Элементы.ГруппаДанныеПартнераФизическогоЛица.Доступность = ПраваДоступаРМК.РедактированиеИнформацииОКлиенте
			И НЕ ДанныеКартыЛояльности.ПартнерДоступен;
		
		Если ПраваДоступаРМК.РедактированиеИнформацииОКлиенте
			И НЕ ДанныеКартыЛояльности.ПартнерДоступен Тогда
			
			Элементы.ЗаписатьДанныеПартнераИЗакрытьФорму.Видимость = Истина;
			Элементы.ЗаписатьДанныеПартнераИЗакрытьФорму.КнопкаПоУмолчанию = Истина;
			Элементы.ЗаписатьИЗакрыть.Видимость = Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
