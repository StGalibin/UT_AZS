﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	ПустойКонтрагент = ИнтеграцияЕГАИС.ПустоеЗначениеОпределяемогоТипа(Метаданные.ОпределяемыеТипы.КонтрагентГИСМ.Имя);
	
	Если ПустойКонтрагент = Неопределено Тогда
		Элементы.ГруппаПроизводительИмпортерТолькоПросмотр.Видимость = Ложь;
		Элементы.ГруппаПроизводительИмпортерРедактирование.Видимость = Ложь;
	ИначеЕсли НЕ ПравоДоступа("Чтение", Метаданные.Справочники.КлассификаторОрганизацийЕГАИС)
		ИЛИ НЕ ПравоДоступа("Чтение", ПустойКонтрагент.Метаданные()) Тогда
		Элементы.ГруппаПроизводительИмпортерТолькоПросмотр.Видимость = Истина;
		Элементы.ГруппаПроизводительИмпортерРедактирование.Видимость = Ложь;
	Иначе
		Элементы.ГруппаПроизводительИмпортерТолькоПросмотр.Видимость = Ложь;
		Элементы.ГруппаПроизводительИмпортерРедактирование.Видимость = Истина;
	КонецЕсли;
	
	Элементы.ВидПродукции.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка." + ИнтеграцияЕГАИС.СправочникВидовАлкогольнойПродукции());
	
	СопоставитьИмпортераИПроизводителя();
	
	УстановитьВидимостьДоступность();
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьПараметрыВыбораНоменклатуры(ЭтотОбъект, "Номенклатура");
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект, "Характеристика", "Объект.Номенклатура");
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект, "Упаковка", "Объект.Номенклатура");
	
	СобытияФормЕГАИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработатьВыборНоменклатурыДляСопоставления(ВыбранноеЗначение, ИсточникВыбора, Объект);
	
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.КлассификаторАлкогольнойПродукцииЕГАИС.Форма.ФормаСопоставленияУпаковок") Тогда
		ЗаполнитьУпаковкиСервер(ВыбранноеЗначение);
	КонецЕсли;
	
	Если ТипЗнч(ВыбранноеЗначение) = ИнтеграцияЕГАИСВызовСервера.ПустоеЗначениеОпределяемогоТипа("Номенклатура") Тогда
		ЗаполнитьСлужебныеПоляИЗависимыеРеквизитыПоНоменклатуре();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
	СобытияФормЕГАИСПереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ОповеститьОЗаписи(ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	
	ЗаполнитьСлужебныеПоляИЗависимыеРеквизитыПоНоменклатуре();
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикаПриИзменении(Элемент)
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура УпаковкаПриИзменении(Элемент)
	
	ПриИзмененииУпаковкиСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура УпаковкаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = ИнтеграцияЕГАИСВызовСервера.ПустоеЗначениеОпределяемогоТипа("Упаковка") Тогда
		СтандартнаяОбработка = Ложь;
		Упаковка = ЕдиницаИзмерения;
		ПриИзмененииУпаковкиСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИмпортерПриИзменении(Элемент)
	
	СопоставитьИмпортераИПроизводителя();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроизводительПриИзменении(Элемент)
	
	СопоставитьИмпортераИПроизводителя();
	
КонецПроцедуры

&НаКлиенте
Процедура УпаковокНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	АдресВХранилище = ПоместитьТаблицуВХранилище();
	
	ПараметрыФормыЗаполнения = Новый Структура();
	ПараметрыФормыЗаполнения.Вставить("НаименованиеАлкогольнойПродукцииЕГАИС", Объект.Наименование);
	ПараметрыФормыЗаполнения.Вставить("Номенклатура", Объект.Номенклатура);
	ПараметрыФормыЗаполнения.Вставить("ЕдиницаИзмерения", ЕдиницаИзмерения);
	ПараметрыФормыЗаполнения.Вставить("УпаковкиИспользуются", УпаковкиИспользуются);
	ПараметрыФормыЗаполнения.Вставить("АдресВХранилище", АдресВХранилище);
	ПараметрыФормыЗаполнения.Вставить("УникальныйИдентификаторДляВременногоХранилища", УникальныйИдентификатор);
	
	ОткрытьФорму("Справочник.КлассификаторАлкогольнойПродукцииЕГАИС.Форма.ФормаСопоставленияУпаковок", 
		ПараметрыФормыЗаполнения, 
		ЭтаФорма,
		,
		,
		,
		,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ТекущаяНоменклатура = Объект.Номенклатура;
	
	ХарактеристикиИспользуются = ГосударственныеИнформационныеСистемыПереопределяемый.ПризнакИспользованияХарактеристик(Объект.Номенклатура);
	УпаковкиИспользуются = ЗначениеЗаполнено(Объект.Номенклатура)
		И ГосударственныеИнформационныеСистемыПереопределяемый.ПризнакИспользованияУпаковок(Объект.Номенклатура);
	
	КоличествоУпаковок = Объект.Упаковки.Количество();
	
	Если КоличествоУпаковок = 1 Тогда
		
		Упаковка = Объект.Упаковки[0].Упаковка;
		
	ИначеЕсли КоличествоУпаковок > 1 Тогда
		
		СформироватьФорматированнуюСтрокуУпаковок();
		
	КонецЕсли;
	
	ЕдиницаИзмерения = ГосударственныеИнформационныеСистемыПереопределяемый.БазоваяЕдиницаИзмеренияНоменклатуры(Объект.Номенклатура);
	
	УстановитьПодсказкуВвода();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьФорматированнуюСтрокуУпаковок()
	
	КоличествоУпаковок = Объект.Упаковки.Количество();
	
	ПараметрыОтбора = Новый Структура("Упаковка", ИнтеграцияЕГАИС.ПустоеЗначениеОпределяемогоТипа("Упаковка"));
	НесопоставленныеСтроки = Объект.Упаковки.НайтиСтроки(ПараметрыОтбора);
	
	КоличествоНесопоставленныхСтрок = НесопоставленныеСтроки.Количество();
	
	ФорматированнаяСтрокаМассив = Новый Массив();
	
	Если КоличествоНесопоставленныхСтрок > 0 Тогда
		ТекстНеСопоставлено = НСтр("ru = 'Не сопоставлено %КоличествоНеСопоставленно% из %КоличествоУпаковок%'");
		ТекстНеСопоставлено = СтрЗаменить(ТекстНеСопоставлено, "%КоличествоУпаковок%", КоличествоУпаковок);
		ТекстНеСопоставлено = СтрЗаменить(ТекстНеСопоставлено, "%КоличествоНеСопоставленно%", КоличествоНесопоставленныхСтрок);
		ФорматированнаяСтрокаМассив.Добавить(Новый ФорматированнаяСтрока(ТекстНеСопоставлено, , ЦветаСтиля.ЦветОтрицательногоЧисла));
	Иначе
		ТекстОткрыть = НСтр("ru = 'Открыть (%КоличествоУпаковок%)'");
		ТекстОткрыть = СтрЗаменить(ТекстОткрыть, "%КоличествоУпаковок%", КоличествоУпаковок);
		ФорматированнаяСтрокаМассив.Добавить(ТекстОткрыть);
	КонецЕсли;
	
	ВсегоУпаковок = Новый ФорматированнаяСтрока(ФорматированнаяСтрокаМассив);

КонецПроцедуры

&НаСервере
Процедура УстановитьПодсказкуВвода()
	
	Элементы.Упаковка.ПодсказкаВвода = ЕдиницаИзмерения;
	
	Если Не ХарактеристикиИспользуются Тогда
		Элементы.Характеристика.ПодсказкаВвода = НСтр("ru = '<Характеристики не используются>'");
	Иначе
		Элементы.Характеристика.ПодсказкаВвода = "";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_КлассификаторАлкогольнойПродукцииЕГАИС", Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииУпаковкиСервер()
	
	Если Объект.Упаковки.Количество() = 0 Тогда
		НоваяСтрока = Объект.Упаковки.Добавить();
		НоваяСтрока.Упаковка = Упаковка;
	Иначе
		Объект.Упаковки[0].Упаковка = Упаковка;
	КонецЕсли;
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаСервере
Процедура СопоставитьИмпортераИПроизводителя()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ЗначениеЗаполнено(Объект.Импортер) Тогда
		КонтрагентИмпортер = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Импортер, "Контрагент");
	Иначе
		КонтрагентИмпортер = ИнтеграцияЕГАИС.ПустоеЗначениеОпределяемогоТипа(Метаданные.ОпределяемыеТипы.КонтрагентГИСМ.Имя);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект.Производитель) Тогда
		КонтрагентПроизводитель = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Производитель, "Контрагент");
	Иначе
		КонтрагентПроизводитель = ИнтеграцияЕГАИС.ПустоеЗначениеОпределяемогоТипа(Метаданные.ОпределяемыеТипы.КонтрагентГИСМ.Имя);
	КонецЕсли;
	
	// Получение текстового представления
	КонтрагентИмпортерТекстовоеПредставление      = Строка(КонтрагентИмпортер);
	КонтрагентПроизводительТекстовоеПредставление = Строка(КонтрагентПроизводитель);
	ИмпортерТекстовоеПредставление                = Строка(Объект.Импортер);
	ПроизводительТекстовоеПредставление           = Строка(Объект.Производитель);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеПоляИЗависимыеРеквизитыПоНоменклатуре()
	
	ЕдиницаИзмерения = ГосударственныеИнформационныеСистемыПереопределяемый.БазоваяЕдиницаИзмеренияНоменклатуры(Объект.Номенклатура);
	
	Если Объект.Номенклатура <> ТекущаяНоменклатура Тогда
		Действия = Новый Структура("ПроверитьХарактеристикуПоВладельцу, ПроверитьЗаполнитьУпаковкуПоВладельцу");
		Действия.Вставить("ПроверитьХарактеристикуПоВладельцу", Объект.Характеристика);
		Действия.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", Упаковка);
		
		СобытияФормЕГАИСПереопределяемый.ПриИзмененииНоменклатурыВФормеКлассификатора(ЭтотОбъект, ТекущаяНоменклатура, Действия);
		
		ТекущаяНоменклатура = Объект.Номенклатура;
	КонецЕсли;
	
	УпаковкиИспользуются = ЗначениеЗаполнено(Объект.Номенклатура)
		И ГосударственныеИнформационныеСистемыПереопределяемый.ПризнакИспользованияУпаковок(Объект.Номенклатура);
		
	ПриИзмененииУпаковкиСервер();
	
	// Установка единицы измерения номенклатуры по умолчанию в качестве упаковки
	Если УпаковкиИспользуются Тогда
		Если Упаковка.Пустая()
			И Объект.Упаковки.Количество() = 0 Тогда
			Упаковка = ЕдиницаИзмерения;
			ПриИзмененииУпаковкиСервер();
		ИначеЕсли Упаковка.Пустая()
			И Объект.Упаковки.Количество() = 1 Тогда
			СтрокаУпаковки = Объект.Упаковки[0];
			Если ПустаяСтрока(СтрокаУпаковки.ИдентификаторУпаковки)
				И СтрокаУпаковки.Упаковка.Пустая() Тогда
				Упаковка = ЕдиницаИзмерения;
				ПриИзмененииУпаковкиСервер();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	СформироватьФорматированнуюСтрокуУпаковок();
	
	УстановитьПодсказкуВвода();
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьУпаковкиСервер(ВыбранноеЗначение)
	
	Упаковки = ПолучитьИзВременногоХранилища(ВыбранноеЗначение.Упаковки).Упаковки;
	
	Объект.Упаковки.Загрузить(Упаковки.Выгрузить());
	
	СформироватьФорматированнуюСтрокуУпаковок();
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступность()
	
	Элементы.Характеристика.Доступность = ХарактеристикиИспользуются;
	Элементы.Упаковка.Доступность = ЗначениеЗаполнено(Объект.Номенклатура);
	
	Если Объект.Упаковки.Количество() > 1 Тогда
		Элементы.Упаковка.Видимость = Ложь;
		Элементы.ВсегоУпаковок.Видимость = Истина;
	Иначе
		Элементы.Упаковка.Видимость = Истина;
		Элементы.ВсегоУпаковок.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ПравоДоступа("Изменение", Метаданные.Справочники.КлассификаторАлкогольнойПродукцииЕГАИС) Тогда
		Элементы.Упаковка.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьТаблицуВХранилище()
	
	Результат = Новый Структура("Упаковки", Объект.Упаковки);
	АдресВХранилище = ПоместитьВоВременноеХранилище(Результат, УникальныйИдентификатор);
	Возврат АдресВХранилище;

КонецФункции

#КонецОбласти
