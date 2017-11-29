﻿
#Область ПрограммныйИнтерфейс

// Процедура согласует и устанавливает значения признаков использования адресного хранения.
//
// Параметры:
//  ОбъектСправочник - СправочникОбъект.Склады - объект-склад для установки признаков.
//
Процедура СогласоватьЗначенияПризнаков(ОбъектСправочник) Экспорт
	
	Если Не ЗначениеЗаполнено(ОбъектСправочник.НастройкаАдресногоХранения) Тогда
		ОбъектСправочник.НастройкаАдресногоХранения = ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.НеИспользовать");
	КонецЕсли;
	
	Если ОбъектСправочник.ЦеховаяКладовая Тогда
		ОбъектСправочник.ИспользоватьОрдернуюСхемуПриОтгрузке = Ложь;
		ОбъектСправочник.ИспользоватьОрдернуюСхемуПриПоступлении = Ложь;
	КонецЕсли;	
	
	Если Не (ОбъектСправочник.ИспользоватьОрдернуюСхемуПриОтгрузке
	 И ОбъектСправочник.ИспользоватьОрдернуюСхемуПриПоступлении
	 И ОбъектСправочник.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач) Тогда
		
		ОбъектСправочник.ИспользоватьСкладскиеПомещения = Ложь;
		
	КонецЕсли;

	Если Не ОбъектСправочник.ИспользоватьОрдернуюСхемуПриОтгрузке Тогда
		ОбъектСправочник.НачинатьОтгрузкуПослеФормированияЗаданияНаПеревозку = Ложь;
	КонецЕсли;
	
	Если Не ОбъектСправочник.ТипСклада = ПредопределенноеЗначение("Перечисление.ТипыСкладов.РозничныйМагазин") Тогда
		ОбъектСправочник.РозничныйВидЦены = ПредопределенноеЗначение("Справочник.ВидыЦен.ПустаяСсылка");
	КонецЕсли;
	
	Если ОбъектСправочник.ИспользоватьСкладскиеПомещения Тогда
		ОбъектСправочник.НастройкаАдресногоХранения = ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.ОпределяетсяНастройкамиПомещения");
	ИначеЕсли ОбъектСправочник.НастройкаАдресногоХранения = ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.ОпределяетсяНастройкамиПомещения") Тогда
		ОбъектСправочник.НастройкаАдресногоХранения = ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.НеИспользовать");
	КонецЕсли;
	
	Если Не (ОбъектСправочник.ИспользоватьОрдернуюСхемуПриОтгрузке
			И ОбъектСправочник.ИспользоватьОрдернуюСхемуПриПоступлении
			И ОбъектСправочник.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач)
		И ОбъектСправочник.НастройкаАдресногоХранения = ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.ЯчейкиОстатки") Тогда
			ОбъектСправочник.НастройкаАдресногоХранения = ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.НеИспользовать");
	КонецЕсли;
	
	Если ОбъектСправочник.НастройкаАдресногоХранения = ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.ЯчейкиОстатки") Тогда
		ОбъектСправочник.ИспользоватьАдресноеХранение          = Истина;
	ИначеЕсли ОбъектСправочник.НастройкаАдресногоХранения = ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.ЯчейкиСправочно") Тогда
		ОбъектСправочник.ИспользоватьАдресноеХранение          = Ложь;
		ОбъектСправочник.ИспользоватьАдресноеХранениеСправочно = Истина;
	Иначе
		ОбъектСправочник.ИспользоватьАдресноеХранение          = Ложь;
		ОбъектСправочник.ИспользоватьАдресноеХранениеСправочно = Ложь;
	КонецЕсли;
	
	Если ОбъектСправочник.НастройкаАдресногоХранения = ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.ОпределяетсяНастройкамиПомещения") Тогда
		ОбъектСправочник.ИспользованиеРабочихУчастков = ПредопределенноеЗначение("Перечисление.ИспользованиеСкладскихРабочихУчастков.ОпределяетсяНастройкамиПомещения");
	ИначеЕсли ОбъектСправочник.НастройкаАдресногоХранения = ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.НеИспользовать") Тогда
		ОбъектСправочник.ИспользованиеРабочихУчастков = ПредопределенноеЗначение("Перечисление.ИспользованиеСкладскихРабочихУчастков.НеИспользовать");
	КонецЕсли;
	
	Если (ОбъектСправочник.НастройкаАдресногоХранения = ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.ОпределяетсяНастройкамиПомещения")
		Или ОбъектСправочник.НастройкаАдресногоХранения = ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.ЯчейкиОстатки")
		Или ОбъектСправочник.ИспользоватьСерииНоменклатуры)
		И ОбъектСправочник.ИспользоватьОрдернуюСхемуПриОтгрузке Тогда
		ОбъектСправочник.ИспользоватьСтатусыРасходныхОрдеров = Истина;
	КонецЕсли;
	
	Если Не ОбъектСправочник.ИспользоватьОрдернуюСхемуПриОтгрузке Тогда
		ОбъектСправочник.ИспользоватьСтатусыРасходныхОрдеров = Ложь;
		ОбъектСправочник.ДатаНачалаОрдернойСхемыПриОтгрузке = Дата(1, 1, 1);
	КонецЕсли;
	
	Если Не ОбъектСправочник.ИспользоватьОрдернуюСхемуПриПоступлении Тогда
		ОбъектСправочник.ИспользоватьСтатусыПриходныхОрдеров = Ложь;
		ОбъектСправочник.ДатаНачалаОрдернойСхемыПриПоступлении = Дата(1, 1, 1);
	КонецЕсли;
	
	Если Не ОбъектСправочник.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач Тогда
		ОбъектСправочник.ДатаНачалаОрдернойСхемыПриОтраженииИзлишковНедостач = Дата(1, 1, 1);
	КонецЕсли;
	
	Если Не ОбъектСправочник.НастройкаАдресногоХранения = ПредопределенноеЗначение("Перечисление.НастройкиАдресногоХранения.ЯчейкиОстатки") Тогда
		ОбъектСправочник.ДатаНачалаАдресногоХраненияОстатков = Дата(1, 1, 1);
	КонецЕсли;
	
	Если Не ОбъектСправочник.ИспользоватьСкладскиеПомещения Тогда
		ОбъектСправочник.ДатаНачалаИспользованияСкладскихПомещений = Дата(1, 1, 1);
	КонецЕсли;
	
	Если ОбъектСправочник.ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач Тогда
		ОбъектСправочник.ИспользоватьСтатусыПересчетовТоваров = Истина;	
	КонецЕсли;
	
КонецПроцедуры

// Поля, по которым отборанные товары могут не сходится с ордером и это не считается недобором
//
// Параметры:
//  Форма			 - УправляемаяФорма							 - текущая форма
//  ТекущиеДанные	 - ДанныеФормыЭлементКоллекции, Неопределенно	 - если данные переданы, то расчитывается для них, если
//  	Неопредленно - то в целом для ТЧ
// 
// Возвращаемое значение:
//  Структура - структура со следующими ключами:
//  * УчитыватьУпаковки - Булево - Истина, если упаковки учитываются
//  * НеУчитываемыеСтатусыСерий - Массив - массив неучитываемых статусов указания серий
//  	** Число - статус указания серии
//  * УчитыватьСерии - Булево - Истина, если серии учитываются
//
Функция УчитываемыеПриПроверкеРасходногоОрдераПоля(Форма, ТекущиеДанные) Экспорт
	
	Результат = Новый Структура("УчитыватьУпаковки,УчитыватьСерии,НеУчитываемыеСтатусыСерий");
	
	Результат.УчитыватьУпаковки = Форма.ИспользуетсяАдресноеХранение;
	
	НеУчитываемыеСтатусыСерий = Новый Массив();
	НеУчитываемыеСтатусыСерий.Добавить(0);
	НеУчитываемыеСтатусыСерий.Добавить(1);
	НеУчитываемыеСтатусыСерий.Добавить(2);
	НеУчитываемыеСтатусыСерий.Добавить(3);
	НеУчитываемыеСтатусыСерий.Добавить(4);
	
	Результат.НеУчитываемыеСтатусыСерий = НеУчитываемыеСтатусыСерий;
	
	Если ТекущиеДанные = Неопределено Тогда
		Результат.УчитыватьСерии = Истина;
	Иначе
		Результат.УчитыватьСерии    = НеУчитываемыеСтатусыСерий.Найти(ТекущиеДанные.СтатусУказанияСерий) = Неопределено;
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

// Проверяет, наличие в массиве складских операций типа "Приемка".
//
// Параметры:
//		СкладскиеОперации - Массив - массив значений складских операций.
//
//	Возвращаемое значение:
//		Булево - Истина, среди элементов массив есть складская операция типа "Примка".
//
Функция ЕстьПриемка(СкладскиеОперации) Экспорт
	
	СкладскиеОперацииПриемки = СкладскиеОперацииПриемки();
	Для Каждого СтрМас из СкладскиеОперации Цикл 
		Если СкладскиеОперацииПриемки.Найти(СтрМас) <> Неопределено Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
		
	Возврат Ложь;
	
КонецФункции

// Возвращает массив значений складских операций типа "Приемка"
//
//	Возвращаемое значение:
//		Массив - массив значений складских операций.
//
Функция СкладскиеОперацииПриемки() Экспорт
	
	МассивОпераций = Новый Массив;
	МассивОпераций.Добавить(ПредопределенноеЗначение("Перечисление.СкладскиеОперации.ВводОстатков"));
	МассивОпераций.Добавить(ПредопределенноеЗначение("Перечисление.СкладскиеОперации.ПриемкаКомплектующихПослеРазборки"));
	МассивОпераций.Добавить(ПредопределенноеЗначение("Перечисление.СкладскиеОперации.ПриемкаОтПоставщика"));
	МассивОпераций.Добавить(ПредопределенноеЗначение("Перечисление.СкладскиеОперации.ПриемкаПоВозвратуОтКлиента"));
	МассивОпераций.Добавить(ПредопределенноеЗначение("Перечисление.СкладскиеОперации.ПриемкаПоПеремещению"));
	МассивОпераций.Добавить(ПредопределенноеЗначение("Перечисление.СкладскиеОперации.ПриемкаПоПрочемуОприходованию"));
	МассивОпераций.Добавить(ПредопределенноеЗначение("Перечисление.СкладскиеОперации.ПриемкаПродукцииИзПроизводства"));
	МассивОпераций.Добавить(ПредопределенноеЗначение("Перечисление.СкладскиеОперации.ПриемкаСобранныхКомплектов"));
	МассивОпераций.Добавить(ПредопределенноеЗначение("Перечисление.СкладскиеОперации.ПроизводствоПродукции"));
	МассивОпераций.Добавить(ПредопределенноеЗначение("Перечисление.СкладскиеОперации.ВыпускПродукцииВПодразделение"));
	МассивОпераций.Добавить(ПредопределенноеЗначение("Перечисление.СкладскиеОперации.ВозвратМатериаловИзПроизводстваПриемка"));
	
	Возврат МассивОпераций;
	
КонецФункции

// Проверяет, наличие в массиве складских операций типа "Отгрузка".
//
// Параметры:
//		СкладскиеОперации - Массив - массив значений складских операций.
//
//	Возвращаемое значение:
//		Булево - Истина, среди элементов массив есть складская операция типа "Отгрузка".
//
Функция ЕстьОтгрузка(СкладскиеОперации) Экспорт
	СкладскиеОперацииОтгрузки = СкладскиеОперацииОтгрузки();
	Для Каждого СтрМас из СкладскиеОперации Цикл 
		Если СкладскиеОперацииОтгрузки.Найти(СтрМас) <> Неопределено Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
		
	Возврат Ложь;
	
КонецФункции

// Возвращает массив значений складских операций типа "Отгрузка"
//
//	Возвращаемое значение:
//		Массив - массив значений складских операций.
//
Функция СкладскиеОперацииОтгрузки() Экспорт
	
	МассивОпераций = Новый Массив;
	МассивОпераций.Добавить(ПредопределенноеЗначение("Перечисление.СкладскиеОперации.ОтгрузкаНаВнутренниеНужды"));
	МассивОпераций.Добавить(ПредопределенноеЗначение("Перечисление.СкладскиеОперации.ОтгрузкаПоВозвратуПоставщику"));
	МассивОпераций.Добавить(ПредопределенноеЗначение("Перечисление.СкладскиеОперации.ПеремещениеМеждуПомещениями"));
	МассивОпераций.Добавить(ПредопределенноеЗначение("Перечисление.СкладскиеОперации.ОтгрузкаКлиенту"));
	МассивОпераций.Добавить(ПредопределенноеЗначение("Перечисление.СкладскиеОперации.ОтгрузкаПоПеремещению"));
	МассивОпераций.Добавить(ПредопределенноеЗначение("Перечисление.СкладскиеОперации.ОтгрузкаКомплектовДляРазборки"));
	МассивОпераций.Добавить(ПредопределенноеЗначение("Перечисление.СкладскиеОперации.ОтгрузкаКомплектующихДляСборки"));
	МассивОпераций.Добавить(ПредопределенноеЗначение("Перечисление.СкладскиеОперации.ПередачаВПроизводствоОтгрузка"));
	
	Возврат МассивОпераций;

КонецФункции

// Проверяет, что строку можно перенести в другой ордер
//
// Параметры:
//  СтрокаТЧ 	- ДанныеФормыЭлементКоллекции	 - проверяемая строка
//  			- Строка табличной части - проверяемая строка
// 
// Возвращаемое значение:
//  Булево - строку можно перенести в другой ордер
//
Функция СтрокуРасходногоОрдераМожноПереноситьВДругойОрдер(СтрокаТЧ) Экспорт
	
	Проверка = Истина;
	
	Если ЗначениеЗаполнено(СтрокаТЧ.УпаковочныйЛистРодитель) Тогда
		ТекстСообщения = НСтр("ru = 'Переносимая строка упакована в упаковочном листе. Поддерживается перенос только упаковочного листа целиком, поэтому нужно или исключить строку из упаковочного листа, или перейти на самый верхний уровень и перенести упаковочный лист целиком.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Проверка = Ложь;
	КонецЕсли;
	
	Если СтрокаТЧ.Действие = ПредопределенноеЗначение("Перечисление.ДействияСоСтрокамиОрдеровНаОтгрузку.НеОтгружать")
		Или СтрокаТЧ.Действие =  ПредопределенноеЗначение("Перечисление.ДействияСоСтрокамиОрдеровНаОтгрузку.Отобрать") Тогда
		
		ТекстСообщения = НСтр("ru = 'Для переносимой строки выбрано действие ""%Действие%"". Можно переносить только строки с действием ""%Отгрузить%""'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Действие%", СтрокаТЧ.Действие);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Отгрузить%", ПредопределенноеЗначение("Перечисление.ДействияСоСтрокамиОрдеровНаОтгрузку.Отгрузить"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Проверка = Ложь;
	КонецЕсли;
	Возврат Проверка;

КонецФункции

// Формирует надпись и картинку для отображения информации о количестве складов в документе.
//
// Параметры:
//	НадписьНесколькоСкладов - ПолеНадписи - поле на форме для отображения количества складов в документе;
//	ПолеКартинки - ПолеКартинки - поле на форме для отображения картинки предупреждения о количестве складов больше одного;
//	КоличествоСкладов Число - количество складов.
//
Процедура ОбновитьКартинкуГруппыСкладов(НадписьНесколькоСкладов, ПолеКартинки, КоличествоСкладов) Экспорт
	
	Если КоличествоСкладов > 1 Тогда
		ПолеКартинки.Картинка = БиблиотекаКартинок.Информация;
		НадписьНесколькоСкладов = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Складов в документе: %1'"), КоличествоСкладов);
	Иначе
		ПолеКартинки.Картинка = Новый Картинка();
		НадписьНесколькоСкладов = "";
	КонецЕсли;
	
КонецПроцедуры

// Заполняет склад в строке ТЧ или в списке строк, если не используется несколько складов
//
// Параметры:
//  ИспользоватьНесколькоСкладов - Булево - Истина, если используется несколько складов
//  СкладПоУмолчанию			 - СправочникСсылка.Склады - Склад по умолчанию
//  СтрокаТЧИлиСписокСтрок		 - ДанныеФормыСтруктура - Строка ТЧ или список строк ТЧ
//  ИмяПоляСклад				 - Строка - Имя реквизита в котором нужно заполнить склад
//
Процедура ЗаполнитьСкладПоУмолчанию(ИспользоватьНесколькоСкладов, СкладПоУмолчанию, СтрокаТЧИлиСписокСтрок, ИмяПоляСклад = "Склад") Экспорт
	
	Если ИспользоватьНесколькоСкладов Тогда
		Возврат;
	КонецЕсли; 

	Если ТипЗнч(СтрокаТЧИлиСписокСтрок) = Тип("Массив") 
		ИЛИ ТипЗнч(СтрокаТЧИлиСписокСтрок) = Тип("ДанныеФормыКоллекция") Тогда
		Для каждого СтрокаТЧ Из СтрокаТЧИлиСписокСтрок Цикл
			СтрокаТЧ[ИмяПоляСклад] = СкладПоУмолчанию;
		КонецЦикла; 
	Иначе
		СтрокаТЧИлиСписокСтрок[ИмяПоляСклад] = СкладПоУмолчанию;
	КонецЕсли; 

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
