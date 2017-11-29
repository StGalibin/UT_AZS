﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ОбменДаннымиУТ.ВЭтомУзлеДоступноВыполнениеОперацийЗакрытияМесяца(Отказ) Тогда
		Возврат;
	КонецЕсли;
	
	// Соберем системные настройки в структуру РежимРаботы.
	РежимРаботы = Новый Структура;
	РежимРаботы.Вставить("БазоваяВерсия", 				 ПолучитьФункциональнуюОпцию("БазоваяВерсия"));
	РежимРаботы.Вставить("УправлениеПредприятием",		 ПолучитьФункциональнуюОпцию("УправлениеПредприятием"));
	РежимРаботы.Вставить("КомплекснаяАвтоматизация",	 ПолучитьФункциональнуюОпцию("КомплекснаяАвтоматизация"));
	РежимРаботы.Вставить("УправлениеТорговлей",			 ПолучитьФункциональнуюОпцию("УправлениеТорговлей"));
	РежимРаботы.Вставить("ВозможнаНастройкаРасписания",  НЕ ОбщегоНазначения.РазделениеВключено());
	
	РежимРаботы.Вставить("ДоступенУправленческийУчет", Истина);
	РежимРаботы.Вставить("ДоступенРегламентированныйУчет",
	    ПолучитьФункциональнуюОпцию("УправлениеТорговлей")
		);
	РежимРаботы.Вставить("ДоступенМеждународныйУчет",
		Ложь
		);
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	Организация = Параметры.Организация;
	ОрганизацияПредыдущая = Организация;
	
	ТекущийПериод = НачалоМесяца(ТекущаяДатаСеанса());
	
	// Выполним настройку свойств элементов формы.
	ЗаполнитьСостояниеРегламентногоЗадания();
	
	НастроитьЭлементыПриИнициализацииФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	СохранитьРеквизитыРегламентногоЗадания();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьРасписаниеРегламентногоЗадания(Команда)
	
	Если РасписаниеРегламентногоЗадания = Неопределено Тогда
		РасписаниеРегламентногоЗадания = Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеРегламентногоЗадания);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"НастроитьРасписаниеРегламентногоЗаданияЗавершение",
		ЭтотОбъект,
		Новый Структура("Диалог", Диалог));
	
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	СохранитьРеквизитыРегламентногоЗадания();
	
	ОрганизацияПредыдущая = Организация;
	
	ЗаполнитьСостояниеРегламентногоЗадания();
	
	НастроитьДоступностьПолей();
	
	СохраняемыйРеквизит = Новый УникальныйИдентификатор;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	ОрганизацияПриИзменении(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрыватьОУПриИзменении(Элемент)
	
	Если ЗакрыватьОУ Тогда
		
		ЗакрываемыйПериодОУ   = ТекущийПериод;
		ПредставлениеПериодОУ = ОбщегоНазначенияУТКлиентСервер.ПолучитьПредставлениеПериодаРегистрации(ЗакрываемыйПериодОУ);
		
		Если НЕ РежимРаботы.ВозможнаНастройкаРасписания
		 И Строка(РасписаниеРегламентногоЗадания) = Строка(Новый РасписаниеРегламентногоЗадания) Тогда
			РасписаниеРегламентногоЗадания = ПредопределенноеРасписание();
		КонецЕсли;
		
	Иначе
		
		ЗакрыватьРУ = Ложь;
		ЗакрыватьМУ = Ложь;
		
		ЗакрываемыйПериодОУ   = Неопределено;
		ПредставлениеПериодОУ = "";
		ЗакрываемыйПериодРУ   = Неопределено;
		ПредставлениеПериодРУ = "";
		ЗакрываемыйПериодМУ   = Неопределено;
		ПредставлениеПериодМУ = "";
		
	КонецЕсли;
	
	НастроитьДоступностьПолей();
	
	СохраняемыйРеквизит = Новый УникальныйИдентификатор;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрыватьРУПриИзменении(Элемент)
	
	Если ЗакрыватьРУ Тогда
		
		ЗакрываемыйПериодРУ   = ЗакрываемыйПериодОУ;
		ПредставлениеПериодРУ = ОбщегоНазначенияУТКлиентСервер.ПолучитьПредставлениеПериодаРегистрации(ЗакрываемыйПериодРУ);
		
		Если НЕ РежимРаботы.ВозможнаНастройкаРасписания
		 И Строка(РасписаниеРегламентногоЗадания) = Строка(Новый РасписаниеРегламентногоЗадания) Тогда
			РасписаниеРегламентногоЗадания = ПредопределенноеРасписание();
		КонецЕсли;
		
	Иначе
		
		ЗакрыватьМУ = Ложь;
		
		ЗакрываемыйПериодРУ   = Неопределено;
		ПредставлениеПериодРУ = "";
		ЗакрываемыйПериодМУ   = Неопределено;
		ПредставлениеПериодМУ = "";
		
	КонецЕсли;
	
	НастроитьДоступностьПолей();
	
	СохраняемыйРеквизит = Новый УникальныйИдентификатор;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрыватьМУПриИзменении(Элемент)
	
	Если ЗакрыватьМУ Тогда
		
		ЗакрываемыйПериодМУ   = ЗакрываемыйПериодРУ;
		ПредставлениеПериодМУ = ОбщегоНазначенияУТКлиентСервер.ПолучитьПредставлениеПериодаРегистрации(ЗакрываемыйПериодМУ);
		
		Если НЕ РежимРаботы.ВозможнаНастройкаРасписания
		 И Строка(РасписаниеРегламентногоЗадания) = Строка(Новый РасписаниеРегламентногоЗадания) Тогда
			РасписаниеРегламентногоЗадания = ПредопределенноеРасписание();
		КонецЕсли;
		
	Иначе
		
		ЗакрываемыйПериодМУ   = Неопределено;
		ПредставлениеПериодМУ = "";
		
	КонецЕсли;
	
	НастроитьДоступностьПолей();
	
	СохраняемыйРеквизит = Новый УникальныйИдентификатор;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИмяРеквизита = СтрЗаменить(Элемент.Имя, "Представление", "Закрываемый");
	
	Оповещение = Новый ОписаниеОповещения(
		"ПредставлениеПериодаНачалоВыбораЗавершение",
		ЭтотОбъект,
		Новый Структура("ИмяРеквизита", ИмяРеквизита));
	
	ПараметрыФормыВыбораПериода = Новый Структура(
		"Значение, РежимВыбораПериода",
		ЭтаФорма[ИмяРеквизита], "МЕСЯЦ");
	
	ОткрытьФорму("ОбщаяФорма.ВыборПериода",
		ПараметрыФормыВыбораПериода, 
		ЭтотОбъект, 
		ЭтотОбъект.УникальныйИдентификатор,
		,
		, 
		Оповещение,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	Если Элемент.Имя = Элементы.ПредставлениеПериодМУ.Имя Тогда
		
		Если Направление = 1 И ЗакрываемыйПериодМУ = ЗакрываемыйПериодРУ Тогда
			
		 	ПоказатьПредупреждение(, 
				НСтр("ru='Закрываемый период международного учета не можеть быть позже,
				|чем закрываемый период регламентированного учета.'"));
			Возврат;
			
		КонецЕсли;
		
	ИначеЕсли Элемент.Имя = Элементы.ПредставлениеПериодРУ.Имя Тогда
		
		Если Направление = 1 И ЗакрываемыйПериодРУ = ЗакрываемыйПериодОУ Тогда
			
			ПоказатьПредупреждение(, 
				НСтр("ru='Закрываемый период регламентированного учета не можеть быть позже,
				|чем закрываемый период оперативного учета.'"));
			Возврат;
			
		ИначеЕсли Направление = -1 И ЗакрываемыйПериодРУ = ЗакрываемыйПериодМУ Тогда
			
			ПоказатьПредупреждение(, 
				НСтр("ru='Закрываемый период регламентированного учета не можеть быть раньше,
				|чем закрываемый период международного учета.'"));
			Возврат;
			
		КонецЕсли;
		
	Иначе // ПредставлениеПериодОУ
		
		Если Направление = -1 И ЗакрываемыйПериодОУ = ЗакрываемыйПериодРУ Тогда
			
			ПоказатьПредупреждение(, 
				НСтр("ru='Закрываемый период оперативного учета не можеть быть раньше,
				|чем закрываемый период регламентированного учета.'"));
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ИмяРеквизита = СтрЗаменить(Элемент.Имя, "Представление", "Закрываемый");
	
	ОбщегоНазначенияУТКлиент.РегулированиеПредставленияПериодаРегистрации(
		Направление,
		СтандартнаяОбработка,
		ЭтаФорма[ИмяРеквизита],
		ЭтаФорма[Элемент.Имя]);
	
	СохраняемыйРеквизит = Новый УникальныйИдентификатор;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьЭлементыПриИнициализацииФормы()
	
	// Заполним список выбора организаций доступными пользователю организациями.
	СписокВыбора = Элементы.Организация.СписокВыбора;
	СписокВыбора.ЗагрузитьЗначения(Справочники.Организации.ДоступныеОрганизации(Истина));
	СписокВыбора.Вставить(0, Справочники.Организации.ПустаяСсылка(), НСтр("ru='<По всем организациям>'"));
	
	ВидимостьМУ = Ложь;
	
	Элементы.ГруппаЗакрытияМесяцаОУ.Доступность = РежимРаботы.ДоступенУправленческийУчет;
	Элементы.ГруппаЗакрытияМесяцаРУ.Доступность = РежимРаботы.ДоступенРегламентированныйУчет;
	Элементы.ГруппаЗакрытияМесяцаМУ.Доступность = РежимРаботы.ДоступенМеждународныйУчет;
	Элементы.ГруппаЗакрытияМесяцаМУ.Видимость   = ВидимостьМУ;
	
	Элементы.НастроитьРасписаниеРегламентногоЗадания.Доступность = РежимРаботы.ВозможнаНастройкаРасписания;
		
	РегистрыСведений.РегламентныеЗаданияЗакрытияМесяца.ЗаполнитьПризнакНаличияЗаданияУОрганизаций(Элементы.Организация.СписокВыбора);
	
	НастроитьДоступностьПолей();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьДоступностьПолей()
	
	Элементы.ПредставлениеПериодОУ.Доступность = ЗакрыватьОУ;
	
	Элементы.ЗакрыватьРУ.Доступность = ЗакрыватьОУ;
	Элементы.ПредставлениеПериодРУ.Доступность = ЗакрыватьРУ;
	
	Элементы.ЗакрыватьМУ.Доступность = ЗакрыватьРУ;
	Элементы.ПредставлениеПериодМУ.Доступность = ЗакрыватьМУ;
	
КонецПРоцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНачалоВыбораЗавершение(ВыбранныйПериод, ДополнительныеПараметры) Экспорт 
	
	Если ВыбранныйПериод = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяЭлемента = СтрЗаменить(ДополнительныеПараметры.ИмяРеквизита, "Закрываемый", "Представление");
	ВыбранныйПериод = НачалоМесяца(ВыбранныйПериод);
	
	Если ИмяЭлемента = Элементы.ПредставлениеПериодМУ.Имя Тогда
		
		Если ВыбранныйПериод > ЗакрываемыйПериодРУ Тогда
			
		 	ПоказатьПредупреждение(, 
				НСтр("ru='Закрываемый период международного учета не можеть быть позже,
				|чем закрываемый период регламентированного учета.'"));
			Возврат;
			
		КонецЕсли;
		
	ИначеЕсли ИмяЭлемента = Элементы.ПредставлениеПериодРУ.Имя Тогда
		
		Если ВыбранныйПериод > ЗакрываемыйПериодОУ Тогда
			
			ПоказатьПредупреждение(, 
				НСтр("ru='Закрываемый период регламентированного учета не можеть быть позже,
				|чем закрываемый период оперативного учета.'"));
			Возврат;
			
		ИначеЕсли ВыбранныйПериод < ЗакрываемыйПериодМУ Тогда
			
			ПоказатьПредупреждение(, 
				НСтр("ru='Закрываемый период регламентированного учета не можеть быть раньше,
				|чем закрываемый период международного учета.'"));
			Возврат;
			
		КонецЕсли;
		
	Иначе // ПредставлениеПериодОУ
		
		Если ВыбранныйПериод < ЗакрываемыйПериодРУ Тогда
			
			ПоказатьПредупреждение(, 
				НСтр("ru='Закрываемый период оперативного учета не можеть быть раньше,
				|чем закрываемый период регламентированного учета.'"));
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ЭтаФорма[ДополнительныеПараметры.ИмяРеквизита] = ВыбранныйПериод;
	ЭтаФорма[ИмяЭлемента] = ОбщегоНазначенияУТКлиентСервер.ПолучитьПредставлениеПериодаРегистрации(ВыбранныйПериод);
	
	СохраняемыйРеквизит = Новый УникальныйИдентификатор;
	
КонецПроцедуры

#Область РегламентноеЗадание

&НаСервере
Процедура ЗаполнитьСостояниеРегламентногоЗадания()
	
	ОписаниеЗадания = РегистрыСведений.РегламентныеЗаданияЗакрытияМесяца.ПолучитьРегламентноеЗаданиеПоОрганизации(Организация);
	
	ЗакрываемыйПериодОУ = ОписаниеЗадания.ЗакрываемыйПериодОУ;
	ЗакрываемыйПериодРУ = ОписаниеЗадания.ЗакрываемыйПериодРУ;
	ЗакрываемыйПериодМУ = ОписаниеЗадания.ЗакрываемыйПериодМУ;
	
	ЗакрыватьОУ = ЗначениеЗаполнено(ЗакрываемыйПериодОУ);
	ЗакрыватьРУ = ЗначениеЗаполнено(ЗакрываемыйПериодРУ);
	ЗакрыватьМУ = ЗначениеЗаполнено(ЗакрываемыйПериодМУ);
	
	ЗаданиеСуществует = ОписаниеЗадания.ЗаданиеСуществует;
	
	Если ОписаниеЗадания.Задание <> Неопределено Тогда
		РасписаниеРегламентногоЗадания = ОписаниеЗадания.Задание.Расписание;
	Иначе
		РасписаниеРегламентногоЗадания = Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;
		
	ОбновитьПредставлениеРасписанияИСостояния(ОписаниеЗадания);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьРеквизитыРегламентногоЗадания()
	
	ИспользованиеЗадания = ЗакрыватьОУ ИЛИ ЗакрыватьРУ ИЛИ ЗакрыватьМУ;
	
	Если НЕ ЗаданиеСуществует И НЕ ИспользованиеЗадания Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеЗадания = РегистрыСведений.РегламентныеЗаданияЗакрытияМесяца.ПолучитьРегламентноеЗаданиеПоОрганизации(ОрганизацияПредыдущая);
	
	ОрганизацииКРасчету = Новый Массив;
	ОрганизацииКРасчету.Добавить(ОрганизацияПредыдущая);
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Использование", ИспользованиеЗадания);
	ПараметрыЗадания.Вставить("Параметры",     ОрганизацииКРасчету);
	ПараметрыЗадания.Вставить("Расписание",    РасписаниеРегламентногоЗадания);
	
	Если ОписаниеЗадания.Задание = Неопределено Тогда
		
		СтрокаНаименования = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Закрытие месяца по организации: %1'"),
			?(ЗначениеЗаполнено(ОрганизацияПредыдущая), СокрЛП(ОрганизацияПредыдущая), НСтр("ru = 'По всем организациям.'")));
		
		ПараметрыЗадания.Вставить("Наименование", СтрокаНаименования);
		ПараметрыЗадания.Вставить("Метаданные",	  Метаданные.РегламентныеЗадания.ЗакрытиеМесяца);
		
		ОписаниеЗадания.Задание = РегламентныеЗаданияСервер.ДобавитьЗадание(ПараметрыЗадания);
		
	Иначе
		
		РегламентныеЗаданияСервер.ИзменитьЗадание(ОписаниеЗадания.Задание, ПараметрыЗадания);
		
	КонецЕсли;
	
	Если ЗакрыватьОУ И НЕ ЗначениеЗаполнено(ЗакрываемыйПериодОУ) Тогда
		ЗакрываемыйПериодОУ = НачалоМесяца(ТекущаяДатаСеанса());
	КонецЕсли;
	Если ЗакрыватьРУ И НЕ ЗначениеЗаполнено(ЗакрываемыйПериодРУ) Тогда
		ЗакрываемыйПериодРУ = НачалоМесяца(ТекущаяДатаСеанса());
	КонецЕсли;
	Если ЗакрыватьМУ И НЕ ЗначениеЗаполнено(ЗакрываемыйПериодМУ) Тогда
		ЗакрываемыйПериодМУ = НачалоМесяца(ТекущаяДатаСеанса());
	КонецЕсли;
	
	ОписаниеЗадания.ИдентификаторЗадания = РегламентныеЗаданияСервер.УникальныйИдентификатор(ОписаниеЗадания.Задание);
	ОписаниеЗадания.СостояниеЗадания 	 = ОбщегоНазначенияУТ.ПолучитьСостояниеПоследнегоЗадания(ОписаниеЗадания.Задание);
	ОписаниеЗадания.Использование 		 = ИспользованиеЗадания;
	ОписаниеЗадания.ЗакрываемыйПериодОУ	 = ?(ЗакрыватьОУ, ЗакрываемыйПериодОУ, Дата(1,1,1));
	ОписаниеЗадания.ЗакрываемыйПериодРУ	 = ?(ЗакрыватьРУ, ЗакрываемыйПериодРУ, Дата(1,1,1));
	ОписаниеЗадания.ЗакрываемыйПериодМУ	 = ?(ЗакрыватьМУ, ЗакрываемыйПериодМУ, Дата(1,1,1));
	
	РегистрыСведений.РегламентныеЗаданияЗакрытияМесяца.ЗаписатьРегламентноеЗаданиеПоОрганизации(ОписаниеЗадания);
	РегистрыСведений.РегламентныеЗаданияЗакрытияМесяца.ЗаполнитьПризнакНаличияЗаданияУОрганизаций(Элементы.Организация.СписокВыбора);
	
	ОбновитьПредставлениеРасписанияИСостояния(ОписаниеЗадания);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПредставлениеРасписанияИСостояния(ОписаниеЗадания = Неопределено)
	
	ПредставлениеПериодОУ = ОбщегоНазначенияУТКлиентСервер.ПолучитьПредставлениеПериодаРегистрации(ЗакрываемыйПериодОУ);
	ПредставлениеПериодРУ = ОбщегоНазначенияУТКлиентСервер.ПолучитьПредставлениеПериодаРегистрации(ЗакрываемыйПериодРУ);
	ПредставлениеПериодМУ = ОбщегоНазначенияУТКлиентСервер.ПолучитьПредставлениеПериодаРегистрации(ЗакрываемыйПериодМУ);
	
	Элементы.НастроитьРасписаниеРегламентногоЗадания.Заголовок =
		АудитСостоянияСистемыКлиентСервер.ПредставлениеРасписания(РасписаниеРегламентногоЗадания);
		
	Если ОписаниеЗадания <> Неопределено И ОписаниеЗадания.СостояниеЗадания <> Неопределено Тогда
		
		Если ОписаниеЗадания.СостояниеЗадания.Состояние = Неопределено Тогда
			СостояниеЗадания = НСтр("ru = 'Не выполнялось'");
		Иначе
			СостояниеЗадания =
				СокрЛП(ОписаниеЗадания.СостояниеЗадания.Состояние) + ": " + СокрЛП(ОписаниеЗадания.СостояниеЗадания.ДатаЗавершения);
		КонецЕсли;
		
	ИначеЕсли ОписаниеЗадания <> Неопределено Тогда
		
		СостояниеЗадания = НСтр("ru='Не настроено'");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписаниеРегламентногоЗаданияЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	
	Диалог = ДополнительныеПараметры.Диалог;
	
	Если Расписание <> Неопределено Тогда
		
		РасписаниеРегламентногоЗадания = Диалог.Расписание;
		ОбновитьПредставлениеРасписанияИСостояния();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПредопределенноеРасписание(ДляМеждународногоУчета = Ложь)
	
	Месяцы = Новый Массив;
	Месяцы.Добавить(1);
	Месяцы.Добавить(2);
	Месяцы.Добавить(3);
	Месяцы.Добавить(4);
	Месяцы.Добавить(5);
	Месяцы.Добавить(6);
	Месяцы.Добавить(7);
	Месяцы.Добавить(8);
	Месяцы.Добавить(9);
	Месяцы.Добавить(10);
	Месяцы.Добавить(11);
	Месяцы.Добавить(12);
	
	ДниНедели = Новый Массив;
	ДниНедели.Добавить(1);
	ДниНедели.Добавить(2);
	ДниНедели.Добавить(3);
	ДниНедели.Добавить(4);
	ДниНедели.Добавить(5);
	ДниНедели.Добавить(6);
	ДниНедели.Добавить(7);
	
	Расписание = Новый РасписаниеРегламентногоЗадания;
	Расписание.Месяцы            = Месяцы;
	Расписание.ДниНедели         = ДниНедели;
	Расписание.ПериодПовтораДней = 1; // каждый день
	
	Расписание.ВремяНачала = Дата('00010101220000'); // 22:00
		
	Возврат Расписание;
	
КонецФункции

#КонецОбласти

#КонецОбласти
