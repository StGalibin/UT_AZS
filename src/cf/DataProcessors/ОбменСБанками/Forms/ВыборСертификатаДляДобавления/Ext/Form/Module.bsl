﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеВыбораСсылка = ПоместитьВоВременноеХранилище(Параметры.ДанныеВыбора, УникальныйИдентификатор);
	
	Элементы.СтраницыСертификата.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	
	Для Каждого КлючЗначение Из Параметры.ДанныеВыбора Цикл
		Элементы.Сертификат.СписокВыбора.Добавить(КлючЗначение.Ключ, КлючЗначение.Значение.Псевдоним);
	КонецЦикла;
	
	Элементы.Сертификат.СписокВыбора.СортироватьПоПредставлению();
	
	Если Параметры.ДанныеВыбора.Количество() = 1 Тогда
		Для Каждого КлючЗначение Из Параметры.ДанныеВыбора Цикл
			Элементы.ПарольОдин.АктивизироватьПоУмолчанию = Истина;
			Элементы.СтраницыСертификата.ТекущаяСтраница = Элементы.ОдинСертификат;
			Сертификат = КлючЗначение.Ключ;
			ПредставлениеСертификата = КлючЗначение.Значение.Псевдоним;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Ок(Команда)
	
	Если Не ЗначениеЗаполнено(Сертификат) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Выберите ключ'"), , "Сертификат");
		Возврат;
	КонецЕсли;
	ДанныеСертификата = ПолучитьИзВременногоХранилища(ДанныеВыбораСсылка);
	
	СтруктураВозврата = Новый Структура;
	СтруктураВозврата.Вставить("Отпечаток", Сертификат);
	СтруктураСертификата = ДанныеСертификата.Получить(Сертификат);
	СтруктураВозврата.Вставить("СертификатBase64", СтруктураСертификата.СертификатBase64);
	СтруктураВозврата.Вставить("Пароль", Пароль);
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

#КонецОбласти
