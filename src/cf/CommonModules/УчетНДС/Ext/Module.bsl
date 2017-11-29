﻿////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции формирования отчетности по НДС.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс


#Область ВыводКнигИЖурналов

// Формирует список кодов видов операций, актуальный на переданную дату.
//
// Параметры:
//   ЧастьЖурнала         - Перечисления.ЧастиЖурналаУчетаСчетовФактур - список различается для полученных и выставленных счетов-фактур.
//   СписокКодовОпераций  - СписокЗначений - список выбора элемента формы, в который помещается формируемый список кодов видов операций.
//   Дата                 - Дата - дата, на которую требуется получить список кодов видов операций.
//
Процедура ЗаполнитьСписокКодовВидовОпераций(ЧастьЖурнала, СписокКодовОпераций, Период) Экспорт
	
	СписокКодовОпераций.Очистить();
	ВерсияКодовВидовОпераций = УчетНДСКлиентСервер.ВерсияКодовВидовОпераций(Период);
	
	Если ВерсияКодовВидовОпераций = 1 Тогда
		Если ЧастьЖурнала = Перечисления.ЧастиЖурналаУчетаСчетовФактур.ПолученныеСчетаФактуры Тогда
			СписокКодовОпераций.Добавить("01", НСтр("ru = '01 - Получение товаров, работ, услуг'"));
			СписокКодовОпераций.Добавить("02", НСтр("ru = '02 - Авансы выданные'"));
			СписокКодовОпераций.Добавить("03", НСтр("ru = '03 - Возврат от покупателя'"));
			СписокКодовОпераций.Добавить("04", НСтр("ru = '04 - Товары, работы, услуги комитента'"));
			СписокКодовОпераций.Добавить("05", НСтр("ru = '05 - Авансы за товары, работы, услуги комитента'"));
			СписокКодовОпераций.Добавить("10", НСтр("ru = '10 - Безвозмездное получение товаров, работ, услуг'"));
			СписокКодовОпераций.Добавить("11", НСтр("ru = '11 - Полученные товары, права, п.3,4,5.1 ст. 154, пп.1-4 ст. 155 НК'"));
			СписокКодовОпераций.Добавить("12", НСтр("ru = '12 - Авансы выданные за товары, права, п.3,4,5.1 ст. 154, пп.1-4 ст. 155 НК'"));
			СписокКодовОпераций.Добавить("13", НСтр("ru = '13 - Капитальное строительство, модернизация (реконструкция) объектов недвижимости'"));
			СписокКодовОпераций.Добавить("99", НСтр("ru = '99 - Вычет НДС по налоговым накладным'"));
		ИначеЕсли ЧастьЖурнала = Перечисления.ЧастиЖурналаУчетаСчетовФактур.ВыставленныеСчетаФактуры Тогда
			СписокКодовОпераций.Добавить("01", НСтр("ru = '01 - Реализованные товары, работы, услуги'"));
			СписокКодовОпераций.Добавить("02", НСтр("ru = '02 - Авансы полученные'"));
			СписокКодовОпераций.Добавить("03", НСтр("ru = '03 - Возврат поставщику'"));
			СписокКодовОпераций.Добавить("04", НСтр("ru = '04 - Товары, работы, услуги комитента'"));
			СписокКодовОпераций.Добавить("05", НСтр("ru = '05 - Авансы за товары, работы, услуги комитента'"));
			СписокКодовОпераций.Добавить("06", НСтр("ru = '06 - Налоговый агент, ст. 161 НК'"));
			СписокКодовОпераций.Добавить("07", НСтр("ru = '07 - Списание за счет прибыли, пп.2 п.1 ст. 146 НК'"));
			СписокКодовОпераций.Добавить("08", НСтр("ru = '08 - Строительно-монтажные работы, пп.3 п.1 ст. 146 НК'"));
			СписокКодовОпераций.Добавить("09", НСтр("ru = '09 - Суммы, связанные с расчетами по оплате, ст. 162 НК'"));
			СписокКодовОпераций.Добавить("10", НСтр("ru = '10 - Безвозмездная передача товаров, работ, услуг'"));
			СписокКодовОпераций.Добавить("11", НСтр("ru = '11 - Реализованные товары, права, п.3,4,5.1 ст. 154, пп.1-4 ст. 155 НК'"));
			СписокКодовОпераций.Добавить("12", НСтр("ru = '12 - Авансы полученные за товары, права, п.3,4,5.1 ст. 154, пп.1-4 ст. 155 НК'"));
			СписокКодовОпераций.Добавить("13", НСтр("ru = '13 - Капитальное строительство, модернизация (реконструкция) объектов недвижимости'"));
		КонецЕсли;
	ИначеЕсли ВерсияКодовВидовОпераций = 2 Тогда
		Если ЧастьЖурнала = Перечисления.ЧастиЖурналаУчетаСчетовФактур.ПолученныеСчетаФактуры Тогда
			СписокКодовОпераций.Добавить("01", НСтр("ru = '01 - Получение товаров, работ, услуг'"));
			СписокКодовОпераций.Добавить("02", НСтр("ru = '02 - Авансы выданные'"));
			СписокКодовОпераций.Добавить("03", НСтр("ru = '03 - Возврат от покупателя'"));
			СписокКодовОпераций.Добавить("04", НСтр("ru = '04 - Товары, работы, услуги комитента'"));
			СписокКодовОпераций.Добавить("05", НСтр("ru = '05 - Авансы за товары, работы, услуги комитента'"));
			СписокКодовОпераций.Добавить("10", НСтр("ru = '10 - Безвозмездное получение товаров, работ, услуг'"));
			СписокКодовОпераций.Добавить("11", НСтр("ru = '11 - Полученные товары, права, п.3,4,5.1 ст. 154, пп.1-4 ст. 155 НК'"));
			СписокКодовОпераций.Добавить("12", НСтр("ru = '12 - Авансы выданные за товары, права, п.3,4,5.1 ст. 154, пп.1-4 ст. 155 НК'"));
			СписокКодовОпераций.Добавить("13", НСтр("ru = '13 - Капитальное строительство, модернизация (реконструкция) объектов недвижимости'"));
			СписокКодовОпераций.Добавить("16", НСтр("ru = '16 - Возврат от покупателя-неплательщика НДС'"));
			СписокКодовОпераций.Добавить("17", НСтр("ru = '17 - Возврат от покупателя-физического лица'"));
			СписокКодовОпераций.Добавить("18", НСтр("ru = '18 - Изменение стоимости полученных товаров (работ, услуг) в сторону уменьшения'"));
			СписокКодовОпераций.Добавить("19", НСтр("ru = '19 - Ввоз товаров из Евразийского экономического союза'"));
			СписокКодовОпераций.Добавить("20", НСтр("ru = '20 - Ввоз импортных товаров на территорию РФ'"));
			СписокКодовОпераций.Добавить("22", НСтр("ru = '22 - Возврат, зачет авансовых платежей, п.5 ст. 171, п.6 ст. 172 НК'"));
			СписокКодовОпераций.Добавить("23", НСтр("ru = '23 - Командировочные расходы по бланку строгой отчетности, п.7 ст. 171 НК'"));
			СписокКодовОпераций.Добавить("24", НСтр("ru = '24 - Подтверждение ставки 0% после истечения 180 дней'"));
			СписокКодовОпераций.Добавить("25", НСтр("ru = '25 - Подтверждение ставки 0% по ранее восстановленному НДС'"));
			СписокКодовОпераций.Добавить("27", НСтр("ru = '27 - Сводный комиссионный счет-фактура, п.3.1 ст. 169 НК'"));
			СписокКодовОпераций.Добавить("28", НСтр("ru = '28 - Сводный комиссионный счет-фактура на аванс, п.3.1 ст. 169 НК'"));
			СписокКодовОпераций.Добавить("99", НСтр("ru = '99 - Вычет НДС по налоговым накладным'"));
		ИначеЕсли ЧастьЖурнала = Перечисления.ЧастиЖурналаУчетаСчетовФактур.ВыставленныеСчетаФактуры Тогда
			СписокКодовОпераций.Добавить("01", НСтр("ru = '01 - Реализованные товары, работы, услуги'"));
			СписокКодовОпераций.Добавить("02", НСтр("ru = '02 - Авансы полученные'"));
			СписокКодовОпераций.Добавить("03", НСтр("ru = '03 - Возврат поставщику'"));
			СписокКодовОпераций.Добавить("04", НСтр("ru = '04 - Товары, работы, услуги комитента'"));
			СписокКодовОпераций.Добавить("05", НСтр("ru = '05 - Авансы за товары, работы, услуги комитента'"));
			СписокКодовОпераций.Добавить("06", НСтр("ru = '06 - Налоговый агент, ст. 161 НК'"));
			СписокКодовОпераций.Добавить("07", НСтр("ru = '07 - Списание за счет прибыли, пп.2 п.1 ст. 146 НК'"));
			СписокКодовОпераций.Добавить("08", НСтр("ru = '08 - Строительно-монтажные работы, пп.3 п.1 ст. 146 НК'"));
			СписокКодовОпераций.Добавить("09", НСтр("ru = '09 - Суммы, связанные с расчетами по оплате, ст. 162 НК'"));
			СписокКодовОпераций.Добавить("10", НСтр("ru = '10 - Безвозмездная передача товаров, работ, услуг'"));
			СписокКодовОпераций.Добавить("11", НСтр("ru = '11 - Реализованные товары, права, п.3,4,5.1 ст. 154, пп.1-4 ст. 155 НК'"));
			СписокКодовОпераций.Добавить("12", НСтр("ru = '12 - Авансы полученные за товары, права, п.3,4,5.1 ст. 154, пп.1-4 ст. 155 НК'"));
			СписокКодовОпераций.Добавить("13", НСтр("ru = '13 - Капитальное строительство, модернизация (реконструкция) объектов недвижимости'"));
			СписокКодовОпераций.Добавить("16", НСтр("ru = '16 - Возврат от покупателя-неплательщика НДС'"));
			СписокКодовОпераций.Добавить("18", НСтр("ru = '18 - Изменение стоимости отгруженных товаров (работ, услуг) в сторону уменьшения'"));
			СписокКодовОпераций.Добавить("21", НСтр("ru = '21 - Восстановление НДС, п.8 ст. 145, п.3 ст. 170, ст. 171.1 НК, а также при операциях, облагаемых по ставке 0%'"));
			СписокКодовОпераций.Добавить("26", НСтр("ru = '26 - Счета-фактуры не составляются по письменному согласию сторон'"));
			СписокКодовОпераций.Добавить("27", НСтр("ru = '27 - Сводный комиссионный счет-фактура, п.3.1 ст. 169 НК'"));
			СписокКодовОпераций.Добавить("28", НСтр("ru = '28 - Сводный комиссионный счет-фактура на аванс, п.3.1 ст. 169 НК'"));
		КонецЕсли;
	ИначеЕсли ВерсияКодовВидовОпераций = 3 Тогда
		Если ЧастьЖурнала = Перечисления.ЧастиЖурналаУчетаСчетовФактур.ПолученныеСчетаФактуры Тогда
			СписокКодовОпераций.Добавить("01", НСтр("ru = '01 - Получение товаров, работ, услуг'"));
			СписокКодовОпераций.Добавить("02", НСтр("ru = '02 - Авансы выданные'"));
			СписокКодовОпераций.Добавить("13", НСтр("ru = '13 - Капитальное строительство, модернизация (реконструкция) объектов недвижимости'"));
			СписокКодовОпераций.Добавить("15", НСтр("ru = '15 - Совместное приобретение товаров, работ, услуг для собственных нужд и для комитента'"));
			СписокКодовОпераций.Добавить("16", НСтр("ru = '16 - Возврат от покупателя-неплательщика НДС'"));
			СписокКодовОпераций.Добавить("17", НСтр("ru = '17 - Возврат от покупателя-физического лица'"));
			СписокКодовОпераций.Добавить("18", НСтр("ru = '18 - Изменение стоимости полученных товаров (работ, услуг) в сторону уменьшения'"));
			СписокКодовОпераций.Добавить("19", НСтр("ru = '19 - Ввоз товаров из Евразийского экономического союза'"));
			СписокКодовОпераций.Добавить("20", НСтр("ru = '20 - Ввоз импортных товаров на территорию РФ'"));
			СписокКодовОпераций.Добавить("22", НСтр("ru = '22 - Возврат, зачет авансовых платежей, п.5 ст. 171, п.6 ст. 172 НК'"));
			СписокКодовОпераций.Добавить("23", НСтр("ru = '23 - Командировочные расходы по бланку строгой отчетности, п.7 ст. 171 НК'"));
			СписокКодовОпераций.Добавить("24", НСтр("ru = '24 - Подтверждение ставки 0% после истечения 180 дней'"));
			СписокКодовОпераций.Добавить("25", НСтр("ru = '25 - Вычет НДС при подтверждении ставки 0% по ранее восстановленному НДС, а также п.7 ст.172 НК'"));
			СписокКодовОпераций.Добавить("27", НСтр("ru = '27 - Сводный комиссионный счет-фактура, п.3.1 ст. 169 НК'"));
			СписокКодовОпераций.Добавить("28", НСтр("ru = '28 - Сводный комиссионный счет-фактура на аванс, п.3.1 ст. 169 НК'"));
			СписокКодовОпераций.Добавить("32", НСтр("ru = '32 - Вычет НДС в ОЭЗ Калининградской обл., п.14 ст. 171 НК'"));
		ИначеЕсли ЧастьЖурнала = Перечисления.ЧастиЖурналаУчетаСчетовФактур.ВыставленныеСчетаФактуры Тогда
			СписокКодовОпераций.Добавить("01", НСтр("ru = '01 - Реализация товаров, работ, услуг и операции, приравненные к ней'"));
			СписокКодовОпераций.Добавить("02", НСтр("ru = '02 - Авансы полученные'"));
			СписокКодовОпераций.Добавить("06", НСтр("ru = '06 - Налоговый агент, ст. 161 НК'"));
			СписокКодовОпераций.Добавить("10", НСтр("ru = '10 - Безвозмездная передача товаров, работ, услуг'"));
			СписокКодовОпераций.Добавить("13", НСтр("ru = '13 - Капитальное строительство, модернизация (реконструкция) объектов недвижимости'"));
			СписокКодовОпераций.Добавить("14", НСтр("ru = '14 - Реализация прав, пп.1-4 ст. 155 НК'"));
			СписокКодовОпераций.Добавить("15", НСтр("ru = '15 - Совместная реализация собственных и комиссионных товаров, работ, услуг'"));
			СписокКодовОпераций.Добавить("16", НСтр("ru = '16 - Возврат от покупателя-неплательщика НДС'"));
			СписокКодовОпераций.Добавить("18", НСтр("ru = '18 - Изменение стоимости отгруженных товаров (работ, услуг) в сторону уменьшения'"));
			СписокКодовОпераций.Добавить("21", НСтр("ru = '21 - Восстановление НДС, п.8 ст. 145, п.3 ст. 170, ст. 171.1 НК, а также при операциях, облагаемых по ставке 0%'"));
			СписокКодовОпераций.Добавить("26", НСтр("ru = '26 - Реализация товаров, работ, услуг неплательщикам НДС, получение авансов'"));
			СписокКодовОпераций.Добавить("27", НСтр("ru = '27 - Сводный комиссионный счет-фактура, п.3.1 ст. 169 НК'"));
			СписокКодовОпераций.Добавить("28", НСтр("ru = '28 - Сводный комиссионный счет-фактура на аванс, п.3.1 ст. 169 НК'"));
			СписокКодовОпераций.Добавить("29", НСтр("ru = '29 - Корректировка по п.6 ст. 105.3 НК'"));
			СписокКодовОпераций.Добавить("30", НСтр("ru = '30 - Отгрузка товаров в ОЭЗ Калининградской обл., абз.1 пп.1.1 п.1 ст. 151 НК'"));
			СписокКодовОпераций.Добавить("31", НСтр("ru = '31 - Уплата НДС в ОЭЗ Калининградской обл., абз.2 пп.1.1 п.1 ст. 151 НК'"));
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

// Выводит шапку для дополнительного листа книги покупок или продаж.
//
// Параметры:
//	ТабличныйДокумент - ТабличныйДокумент - Табличный документ, в который выводятся данные.
//	Макет - ТабличныйДокумент - Макет табличного документа.
//	СтруктураПараметров - Структура - Содержит параметры формирования, см. отчеты книга покупок и продаж.
//	НомерДополнительногоЛиста - Число - Номер листа.
//
Процедура ВывестиШапкуДопЛиста(ТабличныйДокумент, Макет, СтруктураПараметров, НомерДополнительногоЛиста) Экспорт
	
	ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
	
	Организация = СтруктураПараметров.Организация;
	
	Если СтруктураПараметров.ЗаполнениеДокумента
		ИЛИ СтруктураПараметров.СформироватьОтчетПоСтандартнойФорме Тогда
		Секция = Макет.ПолучитьОбласть("ШапкаИнформация");
		ТабличныйДокумент.Вывести(Секция);
	КонецЕсли;
	
	Секция = Макет.ПолучитьОбласть("Шапка");
	Если Секция.Области.Найти("НомераГрафДекларация") <> Неопределено Тогда 
		Секция.Область("НомераГрафДекларация").Видимость = Ложь;
	КонецЕсли;
	Секция.Параметры.УстановленныйОтбор = "";
	Секция.Параметры.Период = ПредставлениеПериода(
		СтруктураПараметров.НалоговыйПериод, КонецДня(СтруктураПараметров.КонецНалоговогоПериода), "ФП = Истина");
	
	Если СтруктураПараметров.ДополнительныеЛистыЗаТекущийПериод Тогда
		Секция.Параметры.НомерЛиста = НомерДополнительногоЛиста;	
	КонецЕсли;
		
	СведенияОбОрганизации = БухгалтерскийУчетПереопределяемый.СведенияОЮрФизЛице(Организация);
	
	НазваниеОрганизации = ОбщегоНазначенияБПВызовСервера.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм");;
	
	Секция.Параметры.НазваниеОрганизации = НазваниеОрганизации;
	Секция.Параметры.ИННКППОрганизации = "" + Организация.ИНН + ?(НЕ ЗначениеЗаполнено(Организация.КПП), "", ("/" + Организация.КПП));
	Секция.Параметры.ДатаСоставления = Формат(СтруктураПараметров.ДатаОформления, "ДФ=dd.MM.yyyy");
	
	Если НЕ СтруктураПараметров.ЗаполнениеДокумента 
		И НЕ СтруктураПараметров.СформироватьОтчетПоСтандартнойФорме
		И СтруктураПараметров.ОтбиратьПоКонтрагенту Тогда
		Секция.Параметры.УстановленныйОтбор = СтрШаблон(
			?(ОбщегоНазначения.ОбъектЯвляетсяГруппой(СтруктураПараметров.КонтрагентДляОтбора),
				НСтр("ru='Отбор: Контрагент в группе %1'"),
				НСтр("ru='Отбор: Контрагент = %1'")),
			СтруктураПараметров.КонтрагентДляОтбора);
	КонецЕсли;
	
	ТабличныйДокумент.Вывести(Секция);
	
КонецПроцедуры

// Возвращает дату и номер счета-фактуры для вывода в отчете.
//
// Параметры:
// 	ЗаписьКниги - Структура, ВыборкаИзРезультатаЗапроса - Содержит поля:
//		* СчетФактура - ДокументСсылка.*, ссылка на документ, указываемый в качестве измерения
//						в регистрах НДС.
//		* НомерСчетаФактуры - Строка, номер счета-фактуры полученный предварительно.
//		* ДатаСчетаФактуры  - Дата, дата счета-фактуры, полученная предварительно.
//		* ОбрабатыватьНомерДокумента - Булево, признак того, что необходимо исключить префиксы из номера
//									документа перед печатью.
//		* СчетФактураДокумент - ДокументСсылка.СчетФактураПолученный/СчетФактураВыданный - ссылка на 
//							подчиненный документ "счет-фактура" (необязательный)
//	ЗаписьКнигиПродаж - Булево - Истина, если вызывается для заполнения книги продаж.
//
// Возвращаемое значение:
//	Структура - см. УчетНДСПереопределяемый.ОпределитьДатуИНомерСчетаФактурыДляПечати().
//
Функция ОпределитьДатуИНомерСФ(ЗаписьКниги, ЗаписьКнигиПродаж = Ложь) Экспорт
	
	ВариантыПредставленияСФ = УчетНДСПереопределяемый.ОпределитьДатуИНомерСчетаФактурыДляПечати(
		ЗаписьКниги.СчетФактура,
		ЗаписьКниги.НомерСчетаФактуры,
		ЗаписьКниги.ДатаСчетаФактуры,
		ЗаписьКниги.ОбрабатыватьНомерДокумента,
		ЗаписьКниги.СчетФактураДокумент,
		ЗаписьКнигиПродаж);
	
	Возврат ВариантыПредставленияСФ;
		
КонецФункции

// Возвращает дату и номер корректировочного счета-фактуры.
//
// Параметры:
//	ЗаписьКниги - ВыборкаИзРезультатаЗапроса - Содержит поля:
//		* НомерКорректировки - Строка - Номер корректировочного счета-фактуры.
//		* ДатаКорректировки - Дата - Дата корректировочного счета-фактуры.
//
// Возвращаемое значение:
//	Структура - Содержит ключи:
//		* НомерДата - Строка - Текстовое представление номера и даты счета-фактуры.
//		* Дата - Дата - Текстовое представление даты счета-фактуры.
//		* Номер - Строка - Текстовое представление номера счета-фактуры.
//
Функция ОпределитьНомерИДатуКорректировочногоСФ(ЗаписьКниги) Экспорт
	
	ВариантыПредставленияКоррСчетаФактуры = Новый Структура("НомерДата,Дата,Номер", "", "", "");
	
	Если ЗначениеЗаполнено(ЗаписьКниги.НомерКорректировки) И ЗначениеЗаполнено(ЗаписьКниги.ДатаКорректировки) Тогда
		ВариантыПредставленияКоррСчетаФактуры.Номер = ЗаписьКниги.НомерКорректировки;
		ВариантыПредставленияКоррСчетаФактуры.Дата = Формат(ЗаписьКниги.ДатаКорректировки, "ДФ=dd.MM.yyyy");
		ВариантыПредставленияКоррСчетаФактуры.НомерДата = "" + ЗаписьКниги.НомерКорректировки 
			+ ";" + Формат(ЗаписьКниги.ДатаКорректировки, "ДФ=dd.MM.yyyy");
	КонецЕсли;
	
	Возврат ВариантыПредставленияКоррСчетаФактуры;
	
КонецФункции

// Возвращает дату и номер исправленного счета-фактуры.
//
// Параметры:
//	ЗаписьКниги - ВыборкаИзРезультатаЗапроса - Содержит поля:
//		* НомерИсправления - Строка - Номер исправленного счета-фактуры.
//		* ДатаИсправления - Дата - Дата исправленного счета-фактуры.
//
// Возвращаемое значение:
//	Структура - Содержит ключи:
//		* НомерДата - Строка - Текстовое представление номера и даты счета-фактуры.
//		* Дата - Дата - Текстовое представление даты счета-фактуры.
//		* Номер - Строка - Текстовое представление номера счета-фактуры.
//
Функция ОпределитьНомерИДатуИсправленногоСФ(ЗаписьКниги) Экспорт

	ВариантыПредставленияИсправленногоСчетаФактуры = Новый Структура("НомерДата,Дата,Номер", "", "", "");
	
	Если ЗначениеЗаполнено(ЗаписьКниги.НомерИсправления) И ЗначениеЗаполнено(ЗаписьКниги.ДатаИсправления) Тогда
		ВариантыПредставленияИсправленногоСчетаФактуры.Номер = СокрЛП(ЗаписьКниги.НомерИсправления);
		ВариантыПредставленияИсправленногоСчетаФактуры.Дата = Формат(ЗаписьКниги.ДатаИсправления, "ДФ=dd.MM.yyyy");
		ВариантыПредставленияИсправленногоСчетаФактуры.НомерДата = "" + СокрЛП(ЗаписьКниги.НомерИсправления) 
			+ ";" + Формат(ЗаписьКниги.ДатаИсправления, "ДФ=dd.MM.yyyy");
	КонецЕсли;
	
	Возврат ВариантыПредставленияИсправленногоСчетаФактуры;
	
КонецФункции

// Возвращает дату и номер исправленного корректировочного счета-фактуры.
//
// Параметры:
//	ЗаписьКниги - ВыборкаИзРезультатаЗапроса - Содержит поля:
//		* НомерИсправленияКорректировки - Строка - Номер счета-фактуры.
//		* ДатаИсправленияКорректировки - Дата - Дата счета-фактуры.
//
// Возвращаемое значение:
//	Структура - Содержит ключи:
//		* НомерДата - Строка - Текстовое представление номера и даты счета-фактуры.
//		* Дата - Дата - Текстовое представление даты счета-фактуры.
//		* Номер - Строка - Текстовое представление номера счета-фактуры.
//
Функция ОпределитьНомерИДатуИсправленияКорректировочногоСФ(ЗаписьКниги) Экспорт
	
	ВариантыПредставленияИсправленногоКоррСчетаФактуры = Новый Структура("НомерДата,Дата,Номер", "", "", "");
	
	Если ЗначениеЗаполнено(ЗаписьКниги.НомерИсправленияКорректировки) И ЗначениеЗаполнено(ЗаписьКниги.ДатаИсправленияКорректировки) Тогда
		ВариантыПредставленияИсправленногоКоррСчетаФактуры.Номер = ЗаписьКниги.НомерИсправленияКорректировки;
		ВариантыПредставленияИсправленногоКоррСчетаФактуры.Дата = Формат(ЗаписьКниги.ДатаИсправленияКорректировки, "ДФ=dd.MM.yyyy");
		ВариантыПредставленияИсправленногоКоррСчетаФактуры.НомерДата = "" + ЗаписьКниги.НомерИсправленияКорректировки
			+ ";" + Формат(ЗаписьКниги.ДатаИсправленияКорректировки, "ДФ=dd.MM.yyyy");
	КонецЕсли;
	
	Возврат ВариантыПредставленияИсправленногоКоррСчетаФактуры;
	
КонецФункции

// Возвращает данные об ИНН/КПП в зависимости от вида контрагента.
//
// Параметры:
//	ИНН - Строка - ИНН контрагента.
//	КПП - Строка - КПП контрагента. Пустое значение для физического лица.
//	КонтрагентНаименование - Строка - Наименование контрагента.
//
// Возвращаемое значение:
//	Структура - Содержит ключи:
//		* ИННФЛ - Строка - ИНН (для физического лица)
//		* Фамилия - Строка - Фамилия (для физического лица).
//		* Имя - Строка - Имя (для физического лица)
//		* Отчество - Строка - Отчество (для физического лица).
//		* ИННЮЛ - Строка - ИНН (для юридического лица).
//		* КПП - Строка - КПП (для юридического лица).
//		* НаимОрг - Строка - Наименование (для юридического лица).
//
Функция ПолучитьСтруктуруРеквизитовКонтрагента(ИНН, КПП, Знач КонтрагентНаименование = "") Экспорт
	
	СтруктураРеквизитовКонтрагента = Новый Структура();
	
	Если СтрДлина(СокрЛП(ИНН)) > 10 Тогда
		СтруктураРеквизитовКонтрагента.Вставить("ИННФЛ", ИНН);
		КонтрагентНаименование = СокрЛП(КонтрагентНаименование);
		Если ЗначениеЗаполнено(КонтрагентНаименование) Тогда 
			Если ВРег(Лев(КонтрагентНаименование, 3))  = "ИП " Тогда 
				КонтрагентНаименование = Сред(КонтрагентНаименование, 4)
			ИначеЕсли ВРег(Прав(КонтрагентНаименование, 3))  = " ИП" Тогда 
				КонтрагентНаименование = Лев(КонтрагентНаименование, СтрДлина(КонтрагентНаименование) - 3);
			КонецЕсли;	
			СтруктураФИО = ФизическиеЛицаКлиентСервер.ЧастиИмени(КонтрагентНаименование);
			СтруктураРеквизитовКонтрагента.Вставить("Фамилия", 	?(СтруктураФИО.Фамилия <> Неопределено, СтруктураФИО.Фамилия, ""));
			СтруктураРеквизитовКонтрагента.Вставить("Имя", 		?(СтруктураФИО.Имя <> Неопределено, СтруктураФИО.Имя, ""));
			СтруктураРеквизитовКонтрагента.Вставить("Отчество", ?(СтруктураФИО.Отчество <> Неопределено, СтруктураФИО.Отчество, ""));
		КонецЕсли;	
	Иначе
		СтруктураРеквизитовКонтрагента.Вставить("ИННЮЛ", ИНН);
		СтруктураРеквизитовКонтрагента.Вставить("КПП", КПП);
		Если  ЗначениеЗаполнено(КонтрагентНаименование) Тогда 
			СтруктураРеквизитовКонтрагента.Вставить("НаимОрг", КонтрагентНаименование);
		КонецЕсли;	
	КонецЕсли;
	
	Возврат СтруктураРеквизитовКонтрагента;

КонецФункции

// Добавляет запись книги покупок/продаж для проверки контрагента на сервере ФНС.
//
// Параметры:
//	СтруктураПараметров - Структура - Параметры формирования отчета.
//	Строка - ВыборкаИзРезультатаЗапроса - Данные строки.
//	ОбластьТабличногоДокумента - ТабличныйДокумент - Табличный документ с отчетом.
//	ДетальнаяЗапись - ВыборкаИзРезультатаЗапроса - Детальная запись выборки.
//	НомерРаздела - Число - Номер раздела отчета.
//
Процедура ДобавитьКонтрагентаНаПроверку(СтруктураПараметров, Строка, ОбластьТабличногоДокумента, ДетальнаяЗапись = Неопределено, НомерРаздела = 0) Экспорт
	
	// Если это заполнение документа или декларации по НДС, тогда игнорируем
	Если СтруктураПараметров.Свойство("ЗаполнениеДокумента") И СтруктураПараметров.ЗаполнениеДокумента
		ИЛИ СтруктураПараметров.Свойство("ЗаполнениеДекларации") И СтруктураПараметров.ЗаполнениеДекларации Тогда
		Возврат;
	КонецЕсли;
	
	// Проверка заполненности даты события
	Если СтруктураПараметров.Свойство("ЭтоКнигаПокупок") 
		ИЛИ СтруктураПараметров.Свойство("ЭтоКнигаПродаж") Тогда
		ДатаСобытия	= Строка.ДатаСчетаФактурыСортировка;
	ИначеЕсли СтруктураПараметров.Свойство("ЭтоЖурналУчетаСчетовФактур") Тогда
		ДатаСобытия	= Строка.ДатаСчетаФактуры;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДатаСобытия) Тогда
		Возврат;
	КонецЕсли;
	
	// Если это детальные записи, то ИНН, КПП и контрагента берем из них.
	// Если это итоговая запись, то ИНН, КПП и контрагента берем из их строк.
	Если ДетальнаяЗапись <> Неопределено Тогда
		ДанныеВСтроке = ДетальнаяЗапись;
	Иначе
		ДанныеВСтроке = Строка;
	КонецЕсли;
	
	Контрагент 						= Строка.Контрагент;
	НомерСтрокиТабличногоДокумента 	= ОбластьТабличногоДокумента.Верх;
	Дата 							= НачалоДня(ДатаСобытия);
	Если СтруктураПараметров.Свойство("ЭтоКнигаПокупок") Тогда
		ИНН = ДанныеВСтроке.ПродавецИНН;
		КПП = ДанныеВСтроке.ПродавецКПП;
	ИначеЕсли СтруктураПараметров.Свойство("ЭтоКнигаПродаж") Тогда
		ИНН = ДанныеВСтроке.ПокупательИНН;
		КПП = ДанныеВСтроке.ПокупательКПП;
	ИначеЕсли СтруктураПараметров.Свойство("ЭтоЖурналУчетаСчетовФактур") Тогда
		ИНН = ДанныеВСтроке.КонтрагентИНН;
		КПП = ДанныеВСтроке.КонтрагентКПП;
	КонецЕсли;
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ДобавитьКонтрагентаНаПроверку(
		СтруктураПараметров, 
		НомерСтрокиТабличногоДокумента, 
		Контрагент, 
		ИНН, 
		КПП, 
		Дата, 
		НомерРаздела);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

// Возвращает Истина, если текущую строку книги покупок / продаж необходимо выводить в отчет.
//
// Параметры:
//	СтруктураПараметров - Структура - Параметры формирования отчета.
//	Строка - ВыборкаИзРезультатаЗапроса - Данные строки.
//	ЭтоИтог - Булево - Признак того, что строка является итогом.
//	ДетальнаяЗапись - ВыборкаИзРезультатаЗапроса - Детальная запись выборки.
//
// Возвращаемое значение:
//	Булево - Истина, если строку требуется выводить в отчет.
//
Функция ВыводитьСтроку(СтруктураПараметров, Строка, ЭтоИтог = Ложь, ДетальнаяЗапись = Неопределено) Экспорт
	
	// Если это детальные записи, то ИНН, КПП и контрагента берем из них.
	// Если это итоговая запись, то ИНН, КПП и контрагента берем из их строк.
	Если ДетальнаяЗапись <> Неопределено Тогда
		ДанныеВСтроке = ДетальнаяЗапись;
	Иначе
		ДанныеВСтроке = Строка;
	КонецЕсли;
	
	ВыводитьСтроку = Истина;
	Если ЭтоИтог Тогда
		// В строке итога нет ИНН, КПП и даты, есть только контрагент 
		СтруктураПараметров.Вставить("ЭтоИтог", Истина);
		
		ВыводитьСтроку = ПроверкаКонтрагентов.ВыводитьСтрокуОтчета(
				СтруктураПараметров, 
				ДанныеВСтроке.Контрагент, 
				Неопределено, 
				Неопределено, 
				Неопределено);
	Иначе
		
		СтруктураПараметров.Вставить("ЭтоИтог", Ложь);
		
		Если СтруктураПараметров.Свойство("ЭтоКнигаПокупок") Тогда
				
			ВыводитьСтроку = ПроверкаКонтрагентов.ВыводитьСтрокуОтчета(
				СтруктураПараметров, 
				ДанныеВСтроке.Контрагент, 
				ДанныеВСтроке.ПродавецИНН, 
				ДанныеВСтроке.ПродавецКПП, 
				?(ЗначениеЗаполнено(ДанныеВСтроке.ДатаСчетаФактурыСортировка), ДанныеВСтроке.ДатаСчетаФактурыСортировка, ДанныеВСтроке.СчетФактураДата));
					
		ИначеЕсли СтруктураПараметров.Свойство("ЭтоКнигаПродаж") Тогда
				
				ВыводитьСтроку = ПроверкаКонтрагентов.ВыводитьСтрокуОтчета(
				СтруктураПараметров, 
				ДанныеВСтроке.Контрагент, 
				ДанныеВСтроке.ПокупательИНН, 
				ДанныеВСтроке.ПокупательКПП, 
				?(ЗначениеЗаполнено(ДанныеВСтроке.ДатаСчетаФактурыСортировка), ДанныеВСтроке.ДатаСчетаФактурыСортировка, ДанныеВСтроке.СчетФактураДата));
				
		ИначеЕсли СтруктураПараметров.Свойство("ЭтоЖурналУчетаСчетовФактур") Тогда
				
			ВыводитьСтроку = ПроверкаКонтрагентов.ВыводитьСтрокуОтчета(
				СтруктураПараметров, 
				ДанныеВСтроке.Контрагент, 
				ДанныеВСтроке.КонтрагентИНН, 
				ДанныеВСтроке.КонтрагентКПП, 
				ДанныеВСтроке.ДатаСчетаФактуры);
				
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ВыводитьСтроку;
	
КонецФункции

// Уменьшает итоги по книге покупок / продаж по данным текущей вычитаемой строки.
//
// Параметры:
//	СтрокаИтога - Структура - Содержит ключи для строки итогов книги покупок / продаж.
//	СтрокаВычитаемая - Произвольный - Данные вычитаемой строки.
//	СтруктураПараметров - Структура - Параметры формирования отчета.
//
Процедура УменьшитьСуммуИтога(СтрокаИтога, СтрокаВычитаемая, СтруктураПараметров) Экспорт
	
	Для каждого Колонка Из СтрокаИтога Цикл
		Параметр = Колонка.Ключ;
		СтрокаИтога[Параметр] = СтрокаИтога[Параметр] - СтрокаВычитаемая[Параметр];
	КонецЦикла; 
	
КонецПроцедуры

// Возвращает структуру итогов книги покупок.
//
// Возвращаемое значение:
//	Структура - Содержит ключи для строки итогов книги покупок.
//
Функция НоваяСтрокаИтоговКнигиПокупок() Экспорт

	Результат = Новый Структура();
	Результат.Вставить("ВсегоПокупок", 		0);
	Результат.Вставить("НДС",				0);
	Результат.Вставить("СуммаБезНДС18", 	0);
	Результат.Вставить("НДС18",				0);
	Результат.Вставить("СуммаБезНДС10", 	0);
	Результат.Вставить("НДС10", 			0);
	Результат.Вставить("НДС0", 				0);
	Результат.Вставить("СуммаСовсемБезНДС",	0);
	
	Возврат Результат;

КонецФункции

// Возвращает структуру итогов книги продаж.
//
// Возвращаемое значение:
//	Структура - Содержит ключи для строки итогов книги продаж.
//
Функция НоваяСтрокаИтоговКнигиПродаж() Экспорт

	Результат = Новый Структура();
	Результат.Вставить("ВсегоПродаж", 		0);
	Результат.Вставить("СуммаБезНДС18", 	0);
	Результат.Вставить("НДС18", 			0);
	Результат.Вставить("СуммаБезНДС10", 	0);
	Результат.Вставить("НДС10", 			0);
	Результат.Вставить("НДС0", 				0);
	Результат.Вставить("СуммаСовсемБезНДС",	0);
	
	Возврат Результат;

КонецФункции

// Заменяет пустые значения измерения ИсправленныйСчетФактура регистров НДС на Неопределено.
//
// Параметры:
//	Движения - РегистрНакопленияНаборЗаписей.НДСЗаписиКнигиПокупок,  
//				РегистрНакопленияНаборЗаписей.НДСЗаписиКнигиПродаж - Наборы регистров НДС.
//
Процедура ПривестиПустоеИзмерениеИсправленныйСчетФактура(Движения) Экспорт
	
	Для каждого Движение Из Движения Цикл
	
		Если НЕ ЗначениеЗаполнено(Движение.ИсправленныйСчетФактура)
			И Движение.ИсправленныйСчетФактура <> Неопределено Тогда
			
			Движение.ИсправленныйСчетФактура = Неопределено;
		
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

// Возвращает структуру с отбором для поиска счетов-фактур полученных.
//
// Возвращаемое значение:
//	Структура - Содержит ключи для поиска счета-фактуры.
// 
Функция НовыйПараметрыПоискаСчетовФактур() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("НачалоПериода"      , Неопределено);
	Результат.Вставить("КонецПериода"       , Неопределено);
	Результат.Вставить("Организация"        , Справочники.Организации.ПустаяСсылка());
	Результат.Вставить("Фильтр"             , Неопределено);
	Результат.Вставить("ВсеКромеФильтра"    , Ложь);
	Результат.Вставить("НаличиеСчетаФактуры", Неопределено);
	Результат.Вставить("СчетФактураПроведен", Неопределено);
	Результат.Вставить("ДатаСФНеБолее"      , Неопределено);
	Результат.Вставить("ИскатьПоОборотам"   , Ложь);
	
	Возврат Результат;
	
КонецФункции

// Возвращает значение константы ПредельноеКоличествоЗаписейВРазделеДекларацииПоНДС
// для разделения больших книг покупок и продаж на части.
//
// Возвращаемое значение:
//	Число - число строк в одной порции отчета.
// 
Функция ПредельноеКоличествоЗаписейВРазделеДекларацииПоНДС() Экспорт

	Результат = Константы.ПредельноеКоличествоЗаписейВРазделеДекларацииПоНДС.Получить();
	Если Результат = 0 Тогда
		Результат = 10000;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

// Возвращает текст с названием листа книги покупок или продаж, разделенной на порции.
//
// Параметры:
//	НазваниеРаздела - Строка - Основное название раздела книги.
//	СчетчикСегментов - Число - Номер текущей части.
//
// Возвращаемое значение:
//	Строка - Сформированное название листа.
//
Функция СформироватьЗаголовокЛиста(НазваниеРаздела, СчетчикСегментов) Экспорт

	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1 (часть %2)'"), НазваниеРаздела, СчетчикСегментов);

КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


#КонецОбласти
