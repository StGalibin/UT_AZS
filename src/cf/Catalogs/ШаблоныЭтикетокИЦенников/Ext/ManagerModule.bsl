﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Функция выполняет получение имени поля из доступных полей компоновки данных.
//
// Параметры
//  ИмяПоля  - Строка - Имя поля
//
// Возвращаемое значение:
//   Строка   - Имя поля в шаблоне
//
Функция ИмяПоляВШаблоне(Знач ИмяПоля) Экспорт
	
	ИмяПоля = СтрЗаменить(ИмяПоля, ".DeletionMark", ".ПометкаУдаления");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Owner", ".Владелец");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Code", ".Код");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Parent", ".Родитель");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Predefined", ".Предопределенный");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".IsFolder", ".ЭтоГруппа");
	ИмяПоля = СтрЗаменить(ИмяПоля, ".Description", ".Наименование");
	Возврат ИмяПоля;
	
КонецФункции

// Возвращает шаблон указанного назначения, если он один в базе, иначе - пустую ссылку
//
// Параметры:
//  Назначение - ПеречислениеСсылка.НазначенияШаблоновЭтикетокИЦенников - назначение шаблона
// Возвращаемое значение:
//   СправочникСсылка.ШаблоныЭтикетокИЦенников - Шаблон по-умолчанию.
//
Функция ШаблонПоУмолчанию(Назначение) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 2
	|	ШаблоныЭтикетокИЦенников.Ссылка
	|ИЗ
	|	Справочник.ШаблоныЭтикетокИЦенников КАК ШаблоныЭтикетокИЦенников
	|ГДЕ
	|	ШаблоныЭтикетокИЦенников.Назначение = &Назначение
	|	И НЕ ШаблоныЭтикетокИЦенников.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Назначение",Назначение);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 1 Тогда
		Выборка.Следующий();
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Справочники.ШаблоныЭтикетокИЦенников.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

// Подготовить структуру макета шаблона
//
// Параметры:
//  ПолеТабличногоДокумента	 - ПолеТабличногоДокумента - Поле табличного документа
//  Назначение				 - ПеречислениеСсылка.НазначенияШаблоновЭтикетокИЦенников - Назначение
// 
// Возвращаемое значение:
//  Структура - Структура макета шаблона
//
Функция ПодготовитьСтруктуруМакетаШаблона(ПолеТабличногоДокумента, Назначение) Экспорт
	
	СтруктураМакетаШаблона = Новый Структура;
	ПараметрыШаблона       = Новый Соответствие;
	СчетчикПараметров      = 0;
	ПрефиксИмениПараметра  = "ПараметрМакета";
	
	ОбластьМакетаЭтикетки = ПолеТабличногоДокумента.ПолучитьОбласть(ПолеТабличногоДокумента.ОбластьПечати.Имя);
	СкопироватьСвойстваТабличногоДокумента(ОбластьМакетаЭтикетки, ПолеТабличногоДокумента);
	
	ОбластьМакетаЭтикетки.ОбластьПечати = ОбластьМакетаЭтикетки.Область("R1C1:"+"R"+ОбластьМакетаЭтикетки.ВысотаТаблицы+"C"+ОбластьМакетаЭтикетки.ШиринаТаблицы);
	
	Для НомерКолонки = 1 По ОбластьМакетаЭтикетки.ШиринаТаблицы Цикл
		
		Для НомерСтроки = 1 По ОбластьМакетаЭтикетки.ВысотаТаблицы Цикл
			
			Ячейка = ОбластьМакетаЭтикетки.Область(НомерСтроки, НомерКолонки);
			Если Ячейка.Заполнение = ТипЗаполненияОбластиТабличногоДокумента.Шаблон Тогда
				
				МассивПараметров = ПозицииПараметров(Ячейка.Текст);
				
				КоличествоПараметров = МассивПараметров.Количество();
				Для Индекс = 0 По КоличествоПараметров - 1 Цикл
					
					Структура = МассивПараметров[КоличествоПараметров - 1 - Индекс];
					
					ИмяПараметра = Сред(Ячейка.Текст, Структура.Начало + 1, Структура.Конец - Структура.Начало - 1);
					Если СтрНайти(ИмяПараметра, ПрефиксИмениПараметра) = 0 Тогда
						
						ЛеваяЧасть = Лев(Ячейка.Текст, Структура.Начало);
						ПраваяЧасть = Прав(Ячейка.Текст, СтрДлина(Ячейка.Текст) - Структура.Конец+1);
						
						СохраненноеИмяПараметраМакета = ПараметрыШаблона.Получить(ИмяПараметра);
						Если СохраненноеИмяПараметраМакета = Неопределено Тогда
							СчетчикПараметров = СчетчикПараметров + 1;
							Ячейка.Текст = ЛеваяЧасть + (ПрефиксИмениПараметра + СчетчикПараметров) + ПраваяЧасть;
							ПараметрыШаблона.Вставить(ИмяПараметра, ПрефиксИмениПараметра + СчетчикПараметров);
						Иначе
							Ячейка.Текст = ЛеваяЧасть + (СохраненноеИмяПараметраМакета) + ПраваяЧасть;
						КонецЕсли;
						
					КонецЕсли;
					
				КонецЦикла;
				
			ИначеЕсли Ячейка.Заполнение = ТипЗаполненияОбластиТабличногоДокумента.Параметр Тогда
				
				Если СтрНайти(Ячейка.Параметр, ПрефиксИмениПараметра) = 0 Тогда
					СохраненноеИмяПараметраМакета = ПараметрыШаблона.Получить(Ячейка.Параметр);
					Если СохраненноеИмяПараметраМакета = Неопределено Тогда
						СчетчикПараметров = СчетчикПараметров + 1;
						ПараметрыШаблона.Вставить(Ячейка.Параметр, ПрефиксИмениПараметра + СчетчикПараметров);
						Ячейка.Параметр = ПрефиксИмениПараметра + СчетчикПараметров;
					Иначе
						Ячейка.Параметр = СохраненноеИмяПараметраМакета;
					КонецЕсли;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ТребуетсяПараметрШтрихкод = ПараметрыШаблона.Получить(ИмяПараметраШтрихкод()) = Неопределено;
	ТребуетсяПараметрКодВалюты = ПараметрыШаблона.Получить(ИмяПараметраКодВалюты()) = Неопределено;
	
	// Вставляем в параметры штрихкод
	Для Каждого Рисунок Из ОбластьМакетаЭтикетки.Рисунки Цикл
		Если СтрНайти(Рисунок.Имя, ИмяПараметраШтрихкод()) = 1 Тогда
			Если ТребуетсяПараметрШтрихкод Тогда
				ПараметрыШаблона.Вставить(ИмяПараметраШтрихкод(), ПрефиксИмениПараметра + (СчетчикПараметров+1));
			КонецЕсли;
			// Заменяем на пустую картинку.
			Рисунок.Картинка = Новый Картинка;
		КонецЕсли;
		Если СтрНайти(Рисунок.Имя, "ЗнакВалюты") = 1 Тогда
			Если ТребуетсяПараметрКодВалюты Тогда
				ПараметрыШаблона.Вставить(ИмяПараметраКодВалюты(), ПрефиксИмениПараметра + (СчетчикПараметров+1));
			КонецЕсли;
			// Заменяем на пустую картинку.
			Рисунок.Картинка = Новый Картинка;
		КонецЕсли;
	КонецЦикла;
	
	КоличествоНаСтранице = МаксимальноеКоличествоНаСтранице(ПолеТабличногоДокумента, Назначение);
	
	ОтображатьТекст = Истина;
	
	Если Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаДляСкладскихЯчеек
		ИЛИ Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаСерииНоменклатуры
		ИЛИ Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЭтикеткаУпаковочныхЛистов Тогда
		ТипКода = 4; // Code128
	Иначе
		ТипКода = 1; // EAN13
	КонецЕсли;
	
	РазмерШрифта = 12;
	
	СтруктураМакетаШаблона.Вставить("МакетЭтикетки"            , ОбластьМакетаЭтикетки);
	СтруктураМакетаШаблона.Вставить("ИмяОбластиПечати"         , ОбластьМакетаЭтикетки.ОбластьПечати.Имя);
	СтруктураМакетаШаблона.Вставить("ТипКода"                  , ТипКода);
	СтруктураМакетаШаблона.Вставить("РазмерШрифта"             , РазмерШрифта);
	СтруктураМакетаШаблона.Вставить("ОтображатьТекст"          , ОтображатьТекст);
	СтруктураМакетаШаблона.Вставить("ПараметрыШаблона"         , ПараметрыШаблона);
	СтруктураМакетаШаблона.Вставить("РедакторТабличныйДокумент", ПолеТабличногоДокумента);
	СтруктураМакетаШаблона.Вставить("КоличествоПоВертикали"    , КоличествоНаСтранице.ПоВертикали);
	СтруктураМакетаШаблона.Вставить("КоличествоПоГоризонтали"  , КоличествоНаСтранице.ПоГоризонтали);
	
	Возврат СтруктураМакетаШаблона;
	
КонецФункции

// Максимальное количество на странице.
//
// Параметры:
//  ПолеТабличногоДокумента	 - ПолеТабличногоДокумента - Поле табличного документа.
//  Назначение				 - ПеречислениеСсылка.НазначенияШаблоновЭтикетокИЦенников - Назначение.
// 
// Возвращаемое значение:
//  Структруа - Максимальное количество по горизонтали и вертикали.
//
Функция МаксимальноеКоличествоНаСтранице(ПолеТабличногоДокумента, Назначение) Экспорт
	
	МаксимальноеКоличество = Новый Структура("ПоГоризонтали, ПоВертикали, Описание", 1, 1);
	
	Если Назначение = Перечисления.НазначенияШаблоновЭтикетокИЦенников.ЦенникДляТоваров Тогда
	
		ОбластьМакета = ПолеТабличногоДокумента.ПолучитьОбласть(ПолеТабличногоДокумента.ОбластьПечати.Имя);
		
		РисунокШтрихкода = ОбластьМакета.Рисунки.Добавить(ТипРисункаТабличногоДокумента.Картинка);
		РисунокШтрихкода.Расположить(ОбластьМакета.Область("R1C1:"+"R"+Формат(ОбластьМакета.ВысотаТаблицы,"ЧГ=0")+"C"+Формат(ОбластьМакета.ШиринаТаблицы,"ЧГ=0")));
		
		Если ПолеТабличногоДокумента.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт Тогда
			ВысотаСтраницы = ПолеТабличногоДокумента.ШиринаСтраницы;
			ШиринаСтраницы = ПолеТабличногоДокумента.ВысотаСтраницы;
		Иначе
			ВысотаСтраницы = ПолеТабличногоДокумента.ВысотаСтраницы;
			ШиринаСтраницы = ПолеТабличногоДокумента.ШиринаСтраницы;
		КонецЕсли;
		
		Если НЕ ПолеТабличногоДокумента.АвтоМасштаб Тогда
			Если РисунокШтрихкода.Ширина <> 0 Тогда
				МаксимальноеКоличество.ПоГоризонтали = Цел((ШиринаСтраницы-ПолеТабличногоДокумента.ПолеСлева-ПолеТабличногоДокумента.ПолеСправа)/РисунокШтрихкода.Ширина);
			Иначе
				МаксимальноеКоличество.ПоГоризонтали = 1;
			КонецЕсли;
		Иначе
			МаксимальноеКоличество.ПоГоризонтали = 3;
		КонецЕсли;
		
		Если РисунокШтрихкода.Высота <> 0 Тогда
			МаксимальноеКоличество.ПоВертикали = Цел((ВысотаСтраницы-ПолеТабличногоДокумента.ПолеСверху-ПолеТабличногоДокумента.ПолеСнизу)/РисунокШтрихкода.Высота);
		Иначе
			МаксимальноеКоличество.ПоВертикали = 1;
		КонецЕсли;
		
	КонецЕсли;
	
	РазмерСтраницы = РазмерСтраницы(ПолеТабличногоДокумента);
	
	Описание = НСтр("ru = 'На странице %1 помещается по вертикали: %2, по горизонтали: %3'");
	МаксимальноеКоличество.Описание = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		Описание,
		РазмерСтраницы,
		МаксимальноеКоличество.ПоВертикали,
		МаксимальноеКоличество.ПоГоризонтали);
	
	Возврат МаксимальноеКоличество;
	
КонецФункции

#Область ПечатьОбразцов

// Функция - Получить образцы штрихкодов
//
Функция ПолучитьОбразцыШтрихкодов() Экспорт
	
	Коды = Новый Массив;
	
	ПримерКода = Новый Структура("ТипКода, Наименование, Пример");
	ПримерКода.ТипКода      = 99;
	ПримерКода.Наименование = "Автоопределение";
	ПримерКода.Пример       = "4600051000057";
	Коды.Добавить(ПримерКода);
	
	ПримерКода = Новый Структура("ТипКода, Наименование, Пример");
	ПримерКода.ТипКода      = 0;
	ПримерКода.Наименование = "EAN8";
	ПримерКода.Пример       = "20059217";
	Коды.Добавить(ПримерКода);
	
	ПримерКода = Новый Структура("ТипКода, Наименование, Пример");
	ПримерКода.ТипКода      = 1;
	ПримерКода.Наименование = "EAN13";
	ПримерКода.Пример       = "4600051000057";
	Коды.Добавить(ПримерКода);
	
	ПримерКода = Новый Структура("ТипКода, Наименование, Пример");
	ПримерКода.ТипКода      = 2;
	ПримерКода.Наименование = "EAN128";
	ПримерКода.Пример       = "(01)2595623342995(15)542115(10)ANIMOS53435(00)8685243154";
	Коды.Добавить(ПримерКода);
	
	ПримерКода = Новый Структура("ТипКода, Наименование, Пример");
	ПримерКода.ТипКода      = 3;
	ПримерКода.Наименование = "Code39";
	ПримерКода.Пример       = "2PMP-468-PJM";
	Коды.Добавить(ПримерКода);
	
	ПримерКода = Новый Структура("ТипКода, Наименование, Пример");
	ПримерКода.ТипКода      = 4;
	ПримерКода.Наименование = "Code128";
	ПримерКода.Пример       = "93-0bonUM68";
	Коды.Добавить(ПримерКода);
	
	ПримерКода = Новый Структура("ТипКода, Наименование, Пример");
	ПримерКода.ТипКода      = 6;
	ПримерКода.Наименование = "PDF417";
	ПримерКода.Пример       = "93-0bonUM68";
	Коды.Добавить(ПримерКода);
	
	ПримерКода = Новый Структура("ТипКода, Наименование, Пример");
	ПримерКода.ТипКода      = 11;
	ПримерКода.Наименование = "ITF14";
	ПримерКода.Пример       = "17350053850252";
	Коды.Добавить(ПримерКода);
	
	Возврат Коды;
	
КонецФункции

// Получить параметры для печати образца этикетки товара
//
// Параметры:
//  ДляЧего					 - СправочникСсылка - Назначение
//  ТипКода					 - Число - Тип кода
//  УникальныйИдентификатор	 - УникальныйИдентификатор - Уникальный идентификатор
// 
// Возвращаемое значение:
//  Структура - Параметры печати
//
Функция ПолучитьПараметрыДляПечатиОбразцаЭтикеткиТовара(ДляЧего, ТипКода, УникальныйИдентификатор) Экспорт
	
	Товары = Новый ТаблицаЗначений;
	Товары.Колонки.Добавить("Номенклатура",                Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	Товары.Колонки.Добавить("Характеристика",              Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	Товары.Колонки.Добавить("Упаковка",                    Новый ОписаниеТипов("СправочникСсылка.УпаковкиЕдиницыИзмерения"));
	Товары.Колонки.Добавить("Цена",                        Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("ЦенаДополнительно",           Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("Штрихкод",                    Новый ОписаниеТипов("Строка"));
	Товары.Колонки.Добавить("ШаблонЦенника",               Новый ОписаниеТипов("СправочникСсылка.ШаблоныЭтикетокИЦенников"));
	Товары.Колонки.Добавить("КоличествоЦенников",          Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("ШаблонЭтикетки",              Новый ОписаниеТипов("СправочникСсылка.ШаблоныЭтикетокИЦенников"));
	Товары.Колонки.Добавить("ШаблонЭтикеткиПодготовлено",  Новый ОписаниеТипов("СправочникСсылка.ШаблоныЭтикетокИЦенников"));
	Товары.Колонки.Добавить("КоличествоЭтикеток",                       Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("ОстатокНаСкладе",                          Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("КоличествоВДокументе",                     Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("Весовой",                                  Новый ОписаниеТипов("Булево"));
	Товары.Колонки.Добавить("ДатаПоследнегоИзмененияЦены",              Новый ОписаниеТипов("Дата"));
	Товары.Колонки.Добавить("ДатаПоследнегоИзмененияЦеныДополнительно", Новый ОписаниеТипов("Дата"));
	
	НоваяСтрока = Товары.Добавить();
	НоваяСтрока.Номенклатура      = ДляЧего;
	НоваяСтрока.Цена              = 100;
	НоваяСтрока.ЦенаДополнительно = 100;
	НоваяСтрока.КоличествоЭтикеток = 30;
	
	НоваяСтрока.Штрихкод = "";
	Коды = ПолучитьОбразцыШтрихкодов();
	Для Каждого СтрокаТЧ Из Коды Цикл
		Если СтрокаТЧ.ТипКода = ТипКода Тогда
			НоваяСтрока.Штрихкод = СтрокаТЧ.Пример;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	МаксимальныйКодВесовогоТовара = ПодключаемоеОборудованиеOfflineВызовСервера.МаксимальныйКодВесовогоТовара();
	ПравилоВыгрузкиВВесы = Ложь;
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("Товары", ПоместитьВоВременноеХранилище(Товары, УникальныйИдентификатор));
	ПараметрыПечати.Вставить("Организация", ПолучитьОрганизациюДляПечатиОбразца());
	ПараметрыПечати.Вставить("ПравилоОбмена", ПредопределенноеЗначение("Справочник.ПравилаОбменаСПодключаемымОборудованиемOffline.ПустаяСсылка"));
	ПараметрыПечати.Вставить("МаксимальныйКодВесовогоТовара", МаксимальныйКодВесовогоТовара);
	ПараметрыПечати.Вставить("ПравилоВыгрузкиВВесы",          ПравилоВыгрузкиВВесы);
	ПараметрыПечати.Вставить("ВидЦены",       ПолучитьВидЦеныДляПечатиОбразца());
	ПараметрыПечати.Вставить("Дата",          ТекущаяДатаСеанса());
	ПараметрыПечати.Вставить("ВидЦеныДополнительно", ПолучитьВидЦеныДляПечатиОбразца());
	ПараметрыПечати.Вставить("ДатаДополнительно",    ТекущаяДатаСеанса());
	ПараметрыПечати.Вставить("Склад",                ПолучитьСкладДляПечатиОбразца());
	
	Возврат ПараметрыПечати;
	
КонецФункции

// Получить параметры для печати образца ценника товара
//
// Параметры:
//  ДляЧего					 - СправочникСсылка - Назначение
//  ТипКода					 - Число - Тип кода
//  УникальныйИдентификатор	 - УникальныйИдентификатор - Уникальный идентификатор
// 
// Возвращаемое значение:
//  Структура - Параметры печати
//
Функция ПолучитьПараметрыДляПечатиОбразцаЦенникаТовара(ДляЧего, ТипКода, УникальныйИдентификатор) Экспорт
	
	Товары = Новый ТаблицаЗначений;
	Товары.Колонки.Добавить("Номенклатура",                Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	Товары.Колонки.Добавить("Характеристика",              Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	Товары.Колонки.Добавить("Упаковка",                    Новый ОписаниеТипов("СправочникСсылка.УпаковкиЕдиницыИзмерения"));
	Товары.Колонки.Добавить("Цена",                        Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("ЦенаДополнительно",           Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("Штрихкод",                    Новый ОписаниеТипов("Строка"));
	Товары.Колонки.Добавить("ШаблонЦенника",               Новый ОписаниеТипов("СправочникСсылка.ШаблоныЭтикетокИЦенников"));
	Товары.Колонки.Добавить("КоличествоЦенников",          Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("ШаблонЭтикетки",              Новый ОписаниеТипов("СправочникСсылка.ШаблоныЭтикетокИЦенников"));
	Товары.Колонки.Добавить("ШаблонЭтикеткиПодготовлено",  Новый ОписаниеТипов("СправочникСсылка.ШаблоныЭтикетокИЦенников"));
	Товары.Колонки.Добавить("КоличествоЭтикеток",                       Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("ОстатокНаСкладе",                          Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("КоличествоВДокументе",                     Новый ОписаниеТипов("Число"));
	Товары.Колонки.Добавить("Весовой",                                  Новый ОписаниеТипов("Булево"));
	Товары.Колонки.Добавить("ДатаПоследнегоИзмененияЦены",              Новый ОписаниеТипов("Дата"));
	Товары.Колонки.Добавить("ДатаПоследнегоИзмененияЦеныДополнительно", Новый ОписаниеТипов("Дата"));
	
	НоваяСтрока = Товары.Добавить();
	НоваяСтрока.Номенклатура      = ДляЧего;
	НоваяСтрока.Цена              = 100;
	НоваяСтрока.ЦенаДополнительно = 100;
	НоваяСтрока.КоличествоЦенников = 30;
	
	НоваяСтрока.Штрихкод = "";
	Коды = ПолучитьОбразцыШтрихкодов();
	Для Каждого СтрокаТЧ Из Коды Цикл
		Если СтрокаТЧ.ТипКода = ТипКода Тогда
			НоваяСтрока.Штрихкод = СтрокаТЧ.Пример;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	МаксимальныйКодВесовогоТовара = ПодключаемоеОборудованиеOfflineВызовСервера.МаксимальныйКодВесовогоТовара();
	ПравилоВыгрузкиВВесы = Ложь;
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("Товары", ПоместитьВоВременноеХранилище(Товары, УникальныйИдентификатор));
	ПараметрыПечати.Вставить("Организация",   ПолучитьОрганизациюДляПечатиОбразца());
	ПараметрыПечати.Вставить("ПравилоОбмена", ПредопределенноеЗначение("Справочник.ПравилаОбменаСПодключаемымОборудованиемOffline.ПустаяСсылка"));
	ПараметрыПечати.Вставить("МаксимальныйКодВесовогоТовара", МаксимальныйКодВесовогоТовара);
	ПараметрыПечати.Вставить("ПравилоВыгрузкиВВесы",          ПравилоВыгрузкиВВесы);
	ПараметрыПечати.Вставить("ВидЦены",       ПолучитьВидЦеныДляПечатиОбразца());
	ПараметрыПечати.Вставить("Дата",          ТекущаяДатаСеанса());
	ПараметрыПечати.Вставить("ВидЦеныДополнительно", ПолучитьВидЦеныДляПечатиОбразца());
	ПараметрыПечати.Вставить("ДатаДополнительно",    ТекущаяДатаСеанса());
	ПараметрыПечати.Вставить("Склад",                ПолучитьСкладДляПечатиОбразца());
	
	Возврат ПараметрыПечати;
	
КонецФункции

// Получить параметры для печати образца этикетки складской ячейки
//
// Параметры:
//  ДляЧего					 - СправочникСсылка - Назначение
//  ТипКода					 - Число - Тип кода
//  УникальныйИдентификатор	 - УникальныйИдентификатор - Уникальный идентификатор
// 
// Возвращаемое значение:
//  Структура - Параметры печати
//
Функция ПолучитьПараметрыДляПечатиОбразцаЭтикеткиСкладскойЯчейки(ДляЧего, ТипКода, УникальныйИдентификатор) Экспорт
	
	СкладскиеЯчейки = Новый ТаблицаЗначений;
	СкладскиеЯчейки.Колонки.Добавить("Ячейка", Новый ОписаниеТипов("СправочникСсылка.СкладскиеЯчейки"));
	СкладскиеЯчейки.Колонки.Добавить("Штрихкод", Новый ОписаниеТипов("Строка"));
	
	НоваяСтрока = СкладскиеЯчейки.Добавить();
	НоваяСтрока.Ячейка = ДляЧего;
	
	НоваяСтрока.Штрихкод = "";
	Коды = ПолучитьОбразцыШтрихкодов();
	Для Каждого СтрокаТЧ Из Коды Цикл
		Если СтрокаТЧ.ТипКода = ТипКода Тогда
			НоваяСтрока.Штрихкод = СтрокаТЧ.Пример;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("СкладскиеЯчейки", ПоместитьВоВременноеХранилище(СкладскиеЯчейки, УникальныйИдентификатор));
	ПараметрыПечати.Вставить("ШаблонЭтикетки", Справочники.ШаблоныЭтикетокИЦенников.ПустаяСсылка());
	ПараметрыПечати.Вставить("КоличествоЭкземпляров", 1);
	
	Возврат ПараметрыПечати;
	
КонецФункции

// Получить параметры для печати образца этикетки серии номенклатуры
//
// Параметры:
//  ДляЧего					 - СправочникСсылка - Назначение
//  ТипКода					 - Число - Тип кода
//  УникальныйИдентификатор	 - УникальныйИдентификатор - Уникальный идентификатор
// 
// Возвращаемое значение:
//  Структура - Параметры печати
//
Функция ПолучитьПараметрыДляПечатиОбразцаЭтикеткиСерииНоменклатуры(ДляЧего, ТипКода, УникальныйИдентификатор) Экспорт
	
	СерииНоменклатуры = Новый ТаблицаЗначений;
	СерииНоменклатуры.Колонки.Добавить("Серия",Новый ОписаниеТипов("СправочникСсылка.СерииНоменклатуры"));
	СерииНоменклатуры.Колонки.Добавить("Штрихкод",Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(16)));
	
	НоваяСтрока = СерииНоменклатуры.Добавить();
	НоваяСтрока.Серия = ДляЧего;
	
	НоваяСтрока.Штрихкод = "";
	Коды = ПолучитьОбразцыШтрихкодов();
	Для Каждого СтрокаТЧ Из Коды Цикл
		Если СтрокаТЧ.ТипКода = ТипКода Тогда
			НоваяСтрока.Штрихкод = СтрокаТЧ.Пример;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("АдресВХранилище", ПоместитьВоВременноеХранилище(СерииНоменклатуры, УникальныйИдентификатор));
	ПараметрыПечати.Вставить("ШаблонЭтикетки", Справочники.ШаблоныЭтикетокИЦенников.ПустаяСсылка());
	ПараметрыПечати.Вставить("КоличествоЭкземпляров", 1);
	
	Возврат ПараметрыПечати;
	
КонецФункции

// Получить параметры для печати образца этикетки доставки
//
// Параметры:
//  ДляЧего					 - СправочникСсылка - Назначение
//  УникальныйИдентификатор	 - УникальныйИдентификатор - Уникальный идентификатор
// 
// Возвращаемое значение:
//  Структура - Параметры печати
//
Функция ПолучитьПараметрыДляПечатиОбразцаЭтикеткиДоставки(ДляЧего, УникальныйИдентификатор) Экспорт
	
	ТаблицаДоставки = Новый ТаблицаЗначений;
	ТаблицаДоставки.Колонки.Добавить("Ссылка",            Новый ОписаниеТипов("ДокументСсылка.РеализацияТоваровУслуг,ДокументСсылка.ПеремещениеТоваров"));
	ТаблицаДоставки.Колонки.Добавить("КоличествоПозиций", Новый ОписаниеТипов("Число"));
	ТаблицаДоставки.Колонки.Добавить("Мест",			  Новый ОписаниеТипов("Число"));
	ТаблицаДоставки.Колонки.Добавить("ОбъемНакладной",    Новый ОписаниеТипов("Число"));
	ТаблицаДоставки.Колонки.Добавить("ВесНакладной",      Новый ОписаниеТипов("Число"));
	ТаблицаДоставки.Колонки.Добавить("ШаблонЭтикетки",    Новый ОписаниеТипов("СправочникСсылка.ШаблоныЭтикетокИЦенников"));
	
	НоваяСтрока = ТаблицаДоставки.Добавить();
	НоваяСтрока.Ссылка            = ДляЧего;
	НоваяСтрока.КоличествоПозиций = 100;
	НоваяСтрока.ОбъемНакладной    = 100;
	НоваяСтрока.ВесНакладной      = 100;
	НоваяСтрока.Мест		      = 100;
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("АдресВХранилище", ПоместитьВоВременноеХранилище(ТаблицаДоставки, УникальныйИдентификатор));
	
	Возврат ПараметрыПечати;
	
КонецФункции

// Получить параметры для печати образца этикетки упаковочные листы
//
// Параметры:
//  ДляЧего					 - СправочникСсылка - Назначение
//  ТипКода					 - Число - Тип кода
//  УникальныйИдентификатор	 - УникальныйИдентификатор - Уникальный идентификатор
// 
// Возвращаемое значение:
//  Структура - Параметры печати
//
Функция ПолучитьПараметрыДляПечатиОбразцаЭтикеткиУпаковочныеЛисты(ДляЧего, ТипКода, УникальныйИдентификатор) Экспорт
	
	ТаблицаУпаковочныеЛисты = Новый ТаблицаЗначений;
	ТаблицаУпаковочныеЛисты.Колонки.Добавить("Ссылка", 		Новый ОписаниеТипов("ДокументСсылка.УпаковочныйЛист"));
	ТаблицаУпаковочныеЛисты.Колонки.Добавить("Штрихкод",Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(16)));
	
	НоваяСтрока = ТаблицаУпаковочныеЛисты.Добавить();
	НоваяСтрока.Ссылка = ДляЧего;
	НоваяСтрока.Штрихкод = "";
	Коды = ПолучитьОбразцыШтрихкодов();
	Для Каждого СтрокаТЧ Из Коды Цикл
		Если СтрокаТЧ.ТипКода = ТипКода Тогда
			НоваяСтрока.Штрихкод = СтрокаТЧ.Пример;
			Прервать;
		КонецЕсли;
	КонецЦикла;
		
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("АдресВХранилище", ПоместитьВоВременноеХранилище(ТаблицаУпаковочныеЛисты, УникальныйИдентификатор));
	ПараметрыПечати.Вставить("ШаблонЭтикетки", Справочники.ШаблоныЭтикетокИЦенников.ПустаяСсылка());
	ПараметрыПечати.Вставить("КоличествоЭкземпляров", 1);	
	
	Возврат ПараметрыПечати;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" 
		И Не Параметры.Свойство("Ключ")
		И Не Параметры.Свойство("ОткрытьРедактор")
		И Не Параметры.Свойство("ЗначениеКопирования") Тогда
		
		ВыбраннаяФорма = "ПомощникНового";
		СтандартнаяОбработка = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция РазмерСтраницы(ПолеТабличногоДокумента)
	
	ВысотаСтраницы = ПолеТабличногоДокумента.ВысотаСтраницы;
	ШиринаСтраницы = ПолеТабличногоДокумента.ШиринаСтраницы;
	
	Наименование = Строка(ШиринаСтраницы)+"х"+Строка(ВысотаСтраницы);
	
	Если ШиринаСтраницы = 210 И ВысотаСтраницы = 297 Тогда
		Наименование = "A4";
	ИначеЕсли ШиринаСтраницы = 148 И ВысотаСтраницы = 210 Тогда
		Наименование = "A5";
	ИначеЕсли ШиринаСтраницы = 105 И ВысотаСтраницы = 148 Тогда
		Наименование = "A6";
	ИначеЕсли ШиринаСтраницы = 74 И ВысотаСтраницы = 105 Тогда
		Наименование = "A7";
	ИначеЕсли ШиринаСтраницы = 52 И ВысотаСтраницы = 74 Тогда
		Наименование = "A8";
	ИначеЕсли ШиринаСтраницы = 37 И ВысотаСтраницы = 52 Тогда
		Наименование = "A9";
	ИначеЕсли ШиринаСтраницы = 26 И ВысотаСтраницы = 37 Тогда
		Наименование = "A10";
	КонецЕсли;
	
	Возврат Наименование;
	
КонецФункции

Функция ПозицииПараметров(ТекстЯчейки)
	
	Массив = Новый Массив;
	
	Начало = -1;
	Конец  = -1;
	СчетчикСкобокОткрывающих = 0;
	СчетчикСкобокЗакрывающих = 0;
	
	Для Индекс = 1 По СтрДлина(ТекстЯчейки) Цикл
		Симв = Сред(ТекстЯчейки, Индекс, 1);
		Если Симв = "[" Тогда
			СчетчикСкобокОткрывающих = СчетчикСкобокОткрывающих + 1;
			Если СчетчикСкобокОткрывающих = 1 Тогда
				Начало = Индекс;
			КонецЕсли;
		ИначеЕсли Симв = "]" Тогда
			СчетчикСкобокЗакрывающих = СчетчикСкобокЗакрывающих + 1;
			Если СчетчикСкобокЗакрывающих = СчетчикСкобокОткрывающих Тогда
				Конец = Индекс;
				
				Массив.Добавить(Новый Структура("Начало, Конец", Начало, Конец));
				
				Начало = -1;
				Конец  = -1;
				СчетчикСкобокОткрывающих = 0;
				СчетчикСкобокЗакрывающих = 0;
				
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Массив;
	
КонецФункции

Функция ИмяПараметраШтрихкод() Экспорт
	
	Возврат "Штрихкод";
	
КонецФункции

Функция ИмяПараметраКодВалюты() Экспорт
	
	Возврат "ВидЦены.ВалютаЦены.Код";
	
КонецФункции

Процедура СкопироватьСвойстваТабличногоДокумента(Приемник, Источник)
	
	Приемник.АвтоМасштаб = Источник.АвтоМасштаб;
	Приемник.ВысотаСтраницы = Источник.ВысотаСтраницы;
	Приемник.ИмяПараметровПечати = Источник.ИмяПараметровПечати;
	Приемник.ИмяПринтера = Источник.ИмяПринтера;
	Приемник.КлючПараметровПечати = Источник.КлючПараметровПечати;
	Приемник.КоличествоЭкземпляров = Источник.КоличествоЭкземпляров;
	Приемник.МасштабПечати = Источник.МасштабПечати;
	Приемник.ОриентацияСтраницы = Источник.ОриентацияСтраницы;
	Приемник.ПолеСверху = Источник.ПолеСверху;
	Приемник.ПолеСлева = Источник.ПолеСлева;
	Приемник.ПолеСнизу = Источник.ПолеСнизу;
	Приемник.ПолеСправа = Источник.ПолеСправа;
	Приемник.РазборПоКопиям = Источник.РазборПоКопиям;
	Приемник.РазмерКолонтитулаСверху = Источник.РазмерКолонтитулаСверху;
	Приемник.РазмерКолонтитулаСнизу = Источник.РазмерКолонтитулаСнизу;
	Приемник.РазмерСтраницы = Источник.РазмерСтраницы;
	Приемник.ТочностьПечати = Источник.ТочностьПечати;
	Приемник.ЧерноБелаяПечать = Источник.ЧерноБелаяПечать;
	Приемник.ШиринаСтраницы = Источник.ШиринаСтраницы;
	Приемник.ЭкземпляровНаСтранице = Источник.ЭкземпляровНаСтранице;
	
КонецПроцедуры

#Область ПечатьОбразцов

Функция ПолучитьОрганизациюДляПечатиОбразца()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Данные.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Организации КАК Данные
	|ГДЕ
	|	НЕ Данные.ПометкаУдаления
	|	И Не Данные.Предопределенный
	|");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Справочники.Организации.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

Функция ПолучитьВидЦеныДляПечатиОбразца()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Данные.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ВидыЦен КАК Данные
	|ГДЕ
	|	НЕ Данные.ПометкаУдаления
	|");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Справочники.ВидыЦен.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

Функция ПолучитьСкладДляПечатиОбразца()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	Данные.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Склады КАК Данные
	|ГДЕ
	|	НЕ Данные.ПометкаУдаления
	|");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Справочники.Склады.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли