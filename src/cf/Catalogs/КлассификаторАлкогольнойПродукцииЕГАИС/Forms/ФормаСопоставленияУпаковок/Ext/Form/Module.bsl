﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Номенклатура = Параметры.Номенклатура;
	УпаковкиИспользуются = Параметры.УпаковкиИспользуются;
	НаименованиеАлкогольнойПродукцииЕГАИС = Параметры.НаименованиеАлкогольнойПродукцииЕГАИС;
	ЕдиницаИзмерения = Параметры.ЕдиницаИзмерения;
	
	ШаблонЗаголовка = НСтр("ru = 'Сопоставление упаковок алкогольной продукции %НаименованиеНоменклатуры%'");
	Заголовок = СтрЗаменить(ШаблонЗаголовка, "%НаименованиеНоменклатуры%", НаименованиеАлкогольнойПродукцииЕГАИС);
	
	УпаковкиКлассификатора = ПолучитьИзВременногоХранилища(Параметры.АдресВХранилище).Упаковки;
	Упаковки.Загрузить(УпаковкиКлассификатора.Выгрузить());
	
	УстановитьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	ОчиститьСообщения();
	
	Отказ = Ложь;
	
	ПеренестиВДокументСервер(Отказ);
	
	Если Не Отказ Тогда
		ОповеститьОВыборе(Новый Структура("Упаковки", АдресВХранилище));
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПеренестиВДокументСервер(Отказ)
	
	АдресВХранилище = ПоместитьТаблицуВХранилище();
	
КонецПроцедуры

&НаКлиенте
Процедура УпаковкиУпаковкаПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура УпаковкиПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура УпаковкиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура УпаковкиУпаковкаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = ИнтеграцияЕГАИСВызовСервера.ПустоеЗначениеОпределяемогоТипа("Упаковка") Тогда
		СтандартнаяОбработка = Ложь;
		
		ТекущаяСтрока = Элементы.Упаковки.ТекущиеДанные;
		ТекущаяСтрока.Упаковка = ЕдиницаИзмерения;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормЕГАИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПоместитьТаблицуВХранилище()
	
	Результат = Новый Структура("Упаковки", Упаковки);
	АдресВХранилище = ПоместитьВоВременноеХранилище(Результат, Параметры.УникальныйИдентификаторДляВременногоХранилища);
	Возврат АдресВХранилище;

КонецФункции

&НаСервере
Процедура УстановитьДоступность()
	
	Если Не ЗначениеЗаполнено(Номенклатура) 
		Или Не ПравоДоступа("Изменение", Метаданные.Справочники.КлассификаторАлкогольнойПродукцииЕГАИС) Тогда
		
		Элементы.ПеренестиВДокумент.Доступность = Ложь;
		Элементы.Упаковки.ТолькоПросмотр = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
