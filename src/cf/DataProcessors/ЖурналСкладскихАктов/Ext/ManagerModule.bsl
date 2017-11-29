﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Акт об оприходовании товаров
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.ОприходованиеИзлишковТоваров";
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("ДокументСсылка.ОприходованиеИзлишковТоваров"));
	КомандаПечати.ТипыОбъектовПечати = МассивТипов;
	КомандаПечати.Идентификатор = "АктОбОприходованииТоваров";
	КомандаПечати.Представление = НСтр("ru = 'Акт об оприходовании товаров'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;

	// Задание на размещение товаров
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Обработка.ПечатьЗаданияНаОтборРазмещениеТоваров";
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("ДокументСсылка.ОприходованиеИзлишковТоваров"));
	КомандаПечати.ТипыОбъектовПечати = МассивТипов;
	КомандаПечати.Идентификатор = "ЗаданиеНаОтборРазмещениеТовара";
	КомандаПечати.Представление = НСтр("ru = 'Задание на размещение товаров'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.ДополнительныеПараметры.Вставить("ИмяФормы", "ЗаданиеНаРазмещение");
	КомандаПечати.ДополнительныеПараметры.Вставить("БезДопКолонки");
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьОтветственноеХранение") Тогда
		// МХ-1 
		КомандаПечати = КомандыПечати.Добавить();
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(Тип("ДокументСсылка.ОприходованиеИзлишковТоваров"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ПересортицаТоваров"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ПорчаТоваров"));
		КомандаПечати.ТипыОбъектовПечати = МассивТипов;
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьОбщихФорм";
		КомандаПечати.Идентификатор = "МХ1";
		КомандаПечати.Представление = НСтр("ru='Акт о приеме-передаче ТМЦ на хранение (МХ-1)'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КонецЕсли;
	
	// Акт о списании товаров
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.СписаниеНедостачТоваров";
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("ДокументСсылка.СписаниеНедостачТоваров"));
	КомандаПечати.ТипыОбъектовПечати = МассивТипов;
	КомандаПечати.Идентификатор = "АктСписанияТоваров";
	КомандаПечати.Представление = НСтр("ru = 'Акт о списании товаров'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;

	Если ПравоДоступа("Изменение", Метаданные.Документы.СписаниеНедостачТоваров)
		Тогда
		
		// Акт о списании товаров (ТОРГ-16)
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьТОРГ16";
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(Тип("ДокументСсылка.СписаниеНедостачТоваров"));
		КомандаПечати.ТипыОбъектовПечати = МассивТипов;
		КомандаПечати.Идентификатор = "ТОРГ16";
		КомандаПечати.Представление = НСтр("ru = 'Акт о списании товаров (ТОРГ-16)'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьОтветственноеХранение") Тогда
		// МХ-3 
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьОбщихФорм";
		КомандаПечати.Идентификатор = "МХ3";
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(Тип("ДокументСсылка.СписаниеНедостачТоваров"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ПересортицаТоваров"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ПорчаТоваров"));
		КомандаПечати.ТипыОбъектовПечати = МассивТипов;
		КомандаПечати.Представление = НСтр("ru = 'Акт о возврате ТМЦ, сданных на хранение (МХ-3)'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КонецЕсли;
	
	Если ПравоДоступа("Изменение", Метаданные.Документы.ПорчаТоваров) Тогда
		// Акт о порче, бое, ломе ТМЦ (ТОРГ-15)
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Документ.ПорчаТоваров";
		КомандаПечати.Идентификатор = "ТОРГ15";
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(Тип("ДокументСсылка.ПорчаТоваров"));
		КомандаПечати.ТипыОбъектовПечати = МассивТипов;
		КомандаПечати.ФункциональныеОпции = "ИспользоватьКачествоТоваров";
		КомандаПечати.Представление = НСтр("ru = 'Акт о порче, бое, ломе ТМЦ (ТОРГ-15)'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КонецЕсли;

	// Акт о порче товаров
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "АктПорчиТоваров";
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("ДокументСсылка.ПорчаТоваров"));
	КомандаПечати.ТипыОбъектовПечати = МассивТипов;
	КомандаПечати.МенеджерПечати = "Документ.ПорчаТоваров";
	КомандаПечати.ФункциональныеОпции = "ИспользоватьКачествоТоваров";
	КомандаПечати.Представление = НСтр("ru = 'Акт о порче товаров'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
	// Акт о пересортице товаров
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.ПересортицаТоваров";
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("ДокументСсылка.ПересортицаТоваров"));
	КомандаПечати.ТипыОбъектовПечати = МассивТипов;
	КомандаПечати.Идентификатор = "АктПересортицыТоваров";
	КомандаПечати.Представление = НСтр("ru = 'Акт о пересортице товаров'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
	Если ПравоДоступа("Изменение", Метаданные.Документы.ИнвентаризационнаяОпись) Тогда
		
		// Сличительная ведомость (ИНВ-19)
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьИНВ19";
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(Тип("ДокументСсылка.ИнвентаризационнаяОпись"));
		КомандаПечати.ТипыОбъектовПечати = МассивТипов;
		КомандаПечати.Идентификатор = "ИНВ19";
		КомандаПечати.Представление = НСтр("ru = 'Сличительная ведомость (ИНВ-19)'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		
		// Инвентаризационная опись (ИНВ-3)
		КомандаПечати = КомандыПечати.Добавить();
		КомандаПечати.МенеджерПечати = "Обработка.ПечатьИНВ3";
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(Тип("ДокументСсылка.ИнвентаризационнаяОпись"));
		КомандаПечати.ТипыОбъектовПечати = МассивТипов;
		КомандаПечати.Идентификатор = "ИНВ3";
		КомандаПечати.Представление = НСтр("ru = 'Инвентаризационная опись (ИНВ-3)'");
		КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
		
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти

#Область ТекущиеДела

// Заполняет список текущих дел пользователя.
// Описание параметров процедуры см. в ТекущиеДелаСлужебный.НоваяТаблицаТекущихДел()
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	ИмяФормы = "Обработка.ЖурналСкладскихАктов.Форма.ФормаСписка";
	
	ОбщиеПараметрыЗапросов = ТекущиеДелаСлужебный.ОбщиеПараметрыЗапросов();
	
	// Определим доступны ли текущему пользователю показатели группы
	Доступность =
		(ОбщиеПараметрыЗапросов.ЭтоПолноправныйПользователь
			Или ПравоДоступа("Просмотр", Метаданные.Документы.СписаниеНедостачТоваров))
		И (ПравоДоступа("Добавление", Метаданные.Документы.СписаниеНедостачТоваров)
			ИЛИ ПравоДоступа("Добавление", Метаданные.Документы.ОприходованиеИзлишковТоваров)
			ИЛИ ПравоДоступа("Добавление", Метаданные.Документы.ПересортицаТоваров)
			ИЛИ ПравоДоступа("Добавление", Метаданные.Документы.ПорчаТоваров))
		И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ТоварыКОформлениюИзлишковНедостач);
	
	Если НЕ Доступность Тогда
		Возврат;
	КонецЕсли;
	
	// Расчет показателей
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(1) КАК ОснованияКОформлениюСкладскихАктов
	|ИЗ
	|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|		ТоварыКОформлениюИзлишковНедостачОстатки.Номенклатура КАК Номенклатура,
	|		ТоварыКОформлениюИзлишковНедостачОстатки.Характеристика КАК Характеристика
	|	ИЗ
	|		РегистрНакопления.ТоварыКОформлениюИзлишковНедостач.Остатки(, ) КАК ТоварыКОформлениюИзлишковНедостачОстатки
	|	ГДЕ
	|		ТоварыКОформлениюИзлишковНедостачОстатки.КОформлениюАктовОстаток <> 0) КАК ОстаткиКОформлению";
	
	Результат = ТекущиеДелаСлужебный.ЧисловыеПоказателиТекущихДел(Запрос, ОбщиеПараметрыЗапросов);
	
	// Заполнение дел.
	// ОформлениеСкладскихАктов
	ДелоРодитель = ТекущиеДела.Добавить();
	ДелоРодитель.Идентификатор  = "ОформлениеСкладскихАктов";
	ДелоРодитель.Представление  = НСтр("ru = 'Оформление складских актов'");
	ДелоРодитель.ЕстьДела       = Результат.ОснованияКОформлениюСкладскихАктов > 0;
	ДелоРодитель.Владелец       = Метаданные.Подсистемы.Склад;
	
	// ОснованияКОформлениюСкладскихАктов
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИмяТекущейСтраницы", "СтраницаОснования");
	
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор  = "ОснованияКОформлениюСкладскихАктов";
	Дело.ЕстьДела       = Результат.ОснованияКОформлениюСкладскихАктов > 0;
	Дело.Представление  = НСтр("ru = 'Товары к оформлению'");
	Дело.Количество     = Результат.ОснованияКОформлениюСкладскихАктов;
	Дело.Важное         = Ложь;
	Дело.Форма          = ИмяФормы;
	Дело.ПараметрыФормы = ПараметрыФормы;
	Дело.Владелец       = "ОформлениеСкладскихАктов";
	
КонецПроцедуры

#КонецОбласти

#Область ФормированиеГиперссылкиВЖурналеЗакупок 

Функция ТекстЗапросаКОформлению() Экспорт
	
	Возврат
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ТоварыКОформлениюИзлишковНедостачОстатки.Номенклатура,
	|	ТоварыКОформлениюИзлишковНедостачОстатки.Характеристика,
	|	ТоварыКОформлениюИзлишковНедостачОстатки.Серия,
	|	ТоварыКОформлениюИзлишковНедостачОстатки.Назначение
	|ИЗ
	|	РегистрНакопления.ТоварыКОформлениюИзлишковНедостач.Остатки(
	|			,
	|			Склад = &Склад
	|				ИЛИ &Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)) КАК ТоварыКОформлениюИзлишковНедостачОстатки
	|ГДЕ
	|	НЕ ТоварыКОформлениюИзлишковНедостачОстатки.КОформлениюАктовОстаток = 0";
	
КонецФункции

Функция СформироватьГиперссылкуКОформлению(Параметры) Экспорт
	
	Склад = Параметры.Склад;
	Если ЗначениеЗаполнено(Склад)
			И Не СкладыСервер.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач(Параметры.Склад)
		Или Не СкладыСервер.ЕстьРазрешенныеСкладыОрдерныеПриОтраженииИзлишковНедостач()
		Или Не УправлениеДоступом.ЕстьРоль("ЧтениеТоваровКОформлениюИзлишковНедостач") Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапросаКОформлению());
	Запрос.УстановитьПараметр("Склад",Параметры.Склад);
	ТекстГиперссылки = НСтр("ru='Акты'");
	МассивСтрок = Новый Массив;
	Если Запрос.Выполнить().Пустой() Тогда
		
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(ТекстГиперссылки,,ЦветаСтиля.НезаполненноеПолеТаблицы,,
			"Отчет.ОформлениеИзлишковНедостачТоваров.Форма"));
		
	Иначе
		
		МассивСтрок.Добавить(Новый ФорматированнаяСтрока(ТекстГиперссылки,,,,
			"Отчет.ОформлениеИзлишковНедостачТоваров.Форма"));
		Если УправлениеДоступом.ЕстьРоль("ДобавлениеИзменениеСкладскихАктов") Тогда
			МассивСтрок.Добавить(",");
			МассивСтрок.Добавить(" ");
			МассивСтрок.Добавить(Новый ФорматированнаяСтрока(НСтр("ru='оформить'"),,,,
				"Обработка.ПомощникОформленияСкладскихАктов.Форма"));
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Новый ФорматированнаяСтрока(МассивСтрок);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
