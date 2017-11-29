﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДатаДействующихЦен        = Параметры.ДатаДействующихЦен;
	ПоказыватьИзменениеЦены   = Параметры.ПоказыватьИзменениеЦены;
	ПоказыватьПроцентНаценки  = Параметры.ПоказыватьПроцентНаценки;
	ПоказыватьДействующиеЦены = Параметры.ПоказыватьДействующиеЦены;
	
	УстановитьДоступностьЭлементовФормы(ЭтаФорма);
	
	Если Не Параметры.ПоказыватьДату Тогда
		Элементы.ПоказыватьСтарыеЦены.Заголовок = НСтр("ru='Показывать действующие цены'");
		Элементы.ДатаДействующихЦен.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Применить(Команда)

	СтруктураВозврата = Новый Структура();
	СтруктураВозврата.Вставить("ПоказыватьИзменениеЦены",   ПоказыватьИзменениеЦены);
	СтруктураВозврата.Вставить("ПоказыватьПроцентНаценки",  ПоказыватьПроцентНаценки);
	СтруктураВозврата.Вставить("ПоказыватьДействующиеЦены", ПоказыватьДействующиеЦены);
	СтруктураВозврата.Вставить("ДатаДействующихЦен",        ДатаДействующихЦен);
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьСтарыеЦеныПриИзменении(Элемент)
	
	ОбновитьЗначенияСвязанныхРеквизитов();
	УстановитьДоступностьЭлементовФормы(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементовФормы(Форма)
	
	Форма.Элементы.ДатаДействующихЦен.Доступность       = Форма.ПоказыватьДействующиеЦены;
	Форма.Элементы.ПоказыватьИзменениеЦены.Доступность  = Форма.ПоказыватьДействующиеЦены;
	Форма.Элементы.ПоказыватьПроцентНаценки.Доступность = Форма.ПоказыватьДействующиеЦены;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗначенияСвязанныхРеквизитов()
	
	Если Не ПоказыватьДействующиеЦены Тогда
		ПоказыватьИзменениеЦены = Ложь;
		ПоказыватьПроцентНаценки = Ложь;
		ДатаДействующихЦен = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
