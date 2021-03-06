&НаКлиенте
Процедура Сформировать(Команда)	
	Если Не ПолучитьПараметрыОтчета() = Ложь тогда
    	   	 ПараметрыОтчета = ПолучитьПараметрыОтчета();
		ТабличныйДокументОтчет = ОтобразитьТабличныйДокументОтчет(ПараметрыОтчета);  	
		ТабличныйДокументОтчет.Показать("Отчет по тестированию ("+ПараметрыОтчета.Группа+") за " + ПараметрыОтчета.Дата);
	КонецЕсли;	
КонецПроцедуры 

&НаКлиенте
Функция ПолучитьПараметрыОтчета()
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Дата", Формат(ТекущаяДата(),"ДФ=dd.MM.yyyy"));
	ПараметрыОтчета.Вставить("Группа", Объект.Группа);
	ПараметрыОтчета.Вставить("Практика",Объект.Практика);
	ПараметрыОтчета.Вставить("Студент",Объект.Студент);
	Если Не Объект.Тема.Пустая() Тогда
		ПараметрыОтчета.Вставить("Тема", Объект.Тема);
	Иначе
		ПараметрыОтчета.Вставить("Тема", "");
	КонецЕсли; 
		
	Если Не ЗначениеЗаполнено(ПараметрыОтчета.Группа) И Не ЗначениеЗаполнено(ПараметрыОтчета.Студент) тогда
		Предупреждение("Поле 'Группа' или 'Студент' не заполнено!");	
		Возврат Ложь;
	КонецЕсли; 
	Если Не ЗначениеЗаполнено(ПараметрыОтчета.Практика) Тогда 
		Предупреждение("Поле 'Практика' не заполнено!");	
		Возврат Ложь;
	КонецЕсли;	
	Возврат ПараметрыОтчета;
КонецФункции

&НаСервере
Функция  ПолучитьСписокРезультатов(ПараметрыОтчета)
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Студенты.Ссылка КАК Студент,
		|	Тестирование.Тема КАК Тема,
		|	Тестирование.РезультатТестирования КАК РезультатТестирования,
		|	Группы.Ссылка КАК Группа,
		|	Тестирование.Период КАК Дата,
		|	ПравильныйРезультат.Значение КАК ПравильныйРезультат
		|ИЗ
		|	Справочник.Студенты КАК Студенты
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РезультатТестирования КАК Тестирование
		|		ПО Студенты.Ссылка = Тестирование.Студент,
		|	Константа.ПравильныйРезультат КАК ПравильныйРезультат,
		|	Справочник.Группы КАК Группы
		|ГДЕ
		|	Группы.Ссылка.Наименование = Студенты.Родитель.Наименование
		|	И Студенты.Ссылка.ЭтоГруппа = ЛОЖЬ
		|	И Группы.Ссылка.Наименование = &Группа";
	Запрос.УстановитьПараметр("Группа",ПараметрыОтчета.Группа.Наименование);

	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();	
	
	Возврат ВыборкаДетальныеЗаписи;
КонецФункции

Функция  ПолучитьСписокИнформациюСтудента(ВыборкаДетальныеЗаписи)
	Структура = Новый Структура;
	Структура.Вставить("Студент",ВыборкаДетальныеЗаписи.Студент);
	Структура.Вставить("Группа",ВыборкаДетальныеЗаписи.Группа);
	Структура.Вставить("Тема",ВыборкаДетальныеЗаписи.Тема);        
	Структура.Вставить("Результат",ВыборкаДетальныеЗаписи.РезультатТестирования);
	Структура.Вставить("ДатаВыполнения",ВыборкаДетальныеЗаписи.Дата);
	
	Возврат Структура
КонецФункции

#область Макет
Процедура ВыводГлавнойШапки(ТабличныйДокумент,ОбластьШапки, ОбластьОтборСтудент,ОбластьОтборТема, ПараметрыОтчета)
	ОбластьШапки.Параметры.ДатаОтчета = ПараметрыОтчета.Дата;
	ОбластьШапки.Параметры.Группа = ПараметрыОтчета.Группа;    

	ТабличныйДокумент.Вывести(ОбластьШапки);		
	
	Если ЗначениеЗаполнено(ПараметрыОтчета.Студент) тогда
		ОбластьОтборСтудент.Параметры.Студент = ПараметрыОтчета.Студент; 
		ТабличныйДокумент.Вывести(ОбластьОтборСтудент);		
	КонецЕсли;

	
	Если Не ПараметрыОтчета.Тема = "" И НЕ ПараметрыОтчета.Практика =  "Несдана" тогда
		ОбластьОтборТема.Параметры.Тема = ПараметрыОтчета.Тема;  
		ТабличныйДокумент.Вывести(ОбластьОтборТема);		
	КонецЕсли;                          
		
КонецПроцедуры 


Процедура ВыводСтрокиСдавших(МассивРезультат,ТабличныйДокумент,ОбластьПодвала,ОбластьСтроки,ОбластьШапки,ПараметрыОтчета)
	ТабличныйДокумент.Вывести(ОбластьШапки);
	
	МассивСтудентовСдОдинРаз = Новый Массив;
	Для Сч = 0  По МассивРезультат.Количество()-1 Цикл
		Стд = МассивРезультат[Сч].Студент;
		Если МассивСтудентовСдОдинРаз.Найти(Стд) = Неопределено Тогда 
			МассивСтудентовСдОдинРаз.Добавить(МассивРезультат[Сч].Студент);
		Иначе 
			МассивСтудентовСдОдинРаз.Удалить(МассивСтудентовСдОдинРаз.Найти(Стд));
		КонецЕсли;
	
	КонецЦикла;
	
    	НомерСтроки = 0;
	Для Каждого Студент Из МассивРезультат Цикл
		
		НомерСтроки = НомерСтроки + 1;
		ОбластьСтроки.Параметры.НомерСтроки		= Строка(НомерСтроки) + "."; 
		ОбластьСтроки.Параметры.Студент 			= Студент.Студент;
		ОбластьСтроки.Параметры.Тема 				= Студент.Тема;
		ОбластьСтроки.Параметры.Результат			= Студент.Результат;
		ОбластьСтроки.Параметры.ДатаРезультата	= Студент.ДатаВыполнения;
		
		
		Если МассивСтудентовСдОдинРаз.Найти(Студент.Студент) = Неопределено Тогда 
			ОбластьСтроки.Области.Статус.ЦветФона		= WebЦвета.БледноЗеленый;	
		КонецЕсли;

		
		ТабличныйДокумент.Вывести(ОбластьСтроки);	 
		//Сброс цвета
		ОбластьСтроки.Области.Статус.ЦветФона		= WebЦвета.Белый;	
	КонецЦикла;  
	ОбластьПодвала.Параметры.Количество = НомерСтроки;
	ТабличныйДокумент.Вывести(ОбластьПодвала);	
	
КонецПроцедуры   

Процедура ВыводСтрокиНеПлСдавших(МассивРезультат,ТабличныйДокумент,ОбластьПодвала,ОбластьСтроки,ОбластьШапки,ПараметрыОтчета)
	ТабличныйДокумент.Вывести(ОбластьШапки);
	
    	НомерСтроки = 0;
	Для Каждого Студент Из МассивРезультат Цикл
		
		НомерСтроки = НомерСтроки + 1;
		ОбластьСтроки.Параметры.НомерСтроки		= Строка(НомерСтроки) + "."; 
		ОбластьСтроки.Параметры.Студент 			= Студент.Студент;
		ОбластьСтроки.Параметры.Тема 				= Студент.Тема;
		ОбластьСтроки.Параметры.Результат			= Студент.Результат;
		ОбластьСтроки.Параметры.ДатаРезультата	= Студент.ДатаВыполнения;
		
		ТабличныйДокумент.Вывести(ОбластьСтроки);	 
	КонецЦикла;  
	ОбластьПодвала.Параметры.Количество = НомерСтроки;
	ТабличныйДокумент.Вывести(ОбластьПодвала);	
	
КонецПроцедуры



Процедура ВыводСтрокНеСдавших(МассивНеСдСтудентов,ТабличныйДокумент,ОбластьПодвал,ОбластьСтрокаНеСдавших,ОбластьШапкаТбНеСд,ПараметрыОтчета)
	ТабличныйДокумент.Вывести(ОбластьШапкаТбНеСд);
	НомерСтроки = 0;
	Для Каждого Студент Из МассивНеСдСтудентов Цикл
		НомерСтроки = НомерСтроки + 1;
		ОбластьСтрокаНеСдавших.Параметры.НомерСтроки		= Строка(НомерСтроки) + "."; 
		ОбластьСтрокаНеСдавших.Параметры.Студент 			= Студент.Студент;
		ТабличныйДокумент.Вывести(ОбластьСтрокаНеСдавших);	
	КонецЦикла;     
	ОбластьПодвал.Параметры.Количество = НомерСтроки;
	ТабличныйДокумент.Вывести(ОбластьПодвал);	
КонецПроцедуры     
#КонецОбласти

&НаСервере
Функция ОтобразитьТабличныйДокументОтчет(ПараметрыОтчета)
	ТабличныйДокумент = Новый ТабличныйДокумент();
 
	ТабличныйДокумент.ОтображатьСетку 		= Ложь;
	ТабличныйДокумент.ОтображатьЗаголовки 	= Ложь;
	//ТабличныйДокумент.Защита 					= Истина;
	ТабличныйДокумент.ТолькоПросмотр			= Истина;
	ТабличныйДокумент.АвтоМасштаб				= Истина;
	
	Макет = Отчеты.ОтчетПоРезультатамТестирования.ПолучитьМакет("Отчет");

	ОбластьШапки1		= Макет.ПолучитьОбласть("Шапка");
	ОбластьСтрока		= Макет.ПолучитьОбласть("Строка");
	ОбластьПодвал 	= Макет.ПолучитьОбласть("Подвал");
	ОбластьСтрокаНеСдавших = Макет.ПолучитьОбласть("СтрокаНеСдавших"); 
	
	ОбластьОтборСтудент = Макет.ПолучитьОбласть("ОтборСтудент");
	ОбластьОтборТема		= Макет.ПолучитьОбласть("ОтборТема");
	
	ОбластьШапкаТбНДСд		= Макет.ПолучитьОбласть("ШапкаТбНДСд");
	ОбластьШапкаТбНеСд		= Макет.ПолучитьОбласть("ШапкаТбНеСд");
	ОбластьШапкаТбСд			= Макет.ПолучитьОбласть("ШапкаТбСд");
	
	ВыборкаДетальныеЗаписи = ПолучитьСписокРезультатов(ПараметрыОтчета);
		
	ПравильныйРезультат = Константы.ПравильныйРезультат.Получить();
	
	МассивПолностьюСдСтудентов 		= Новый Массив;
	МассивНеПолностьюСдСтудентов 		= Новый Массив;
	МассивНеСдСтудентов					= Новый Массив; 
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если (ВыборкаДетальныеЗаписи.Тема = ПараметрыОтчета.Тема или ПараметрыОтчета.Тема = "") ИЛИ (ПараметрыОтчета.Практика = "Несдана" И ПараметрыОтчета.Тема = "")  Тогда
            		Если (ЗначениеЗаполнено(Объект.Студент) И ПараметрыОтчета.Студент =  ВыборкаДетальныеЗаписи.Студент) ИЛИ ( Не ЗначениеЗаполнено(Объект.Студент)) тогда
				Если ВыборкаДетальныеЗаписи.РезультатТестирования = ПравильныйРезультат Тогда	
					МассивПолностьюСдСтудентов.Добавить(ПолучитьСписокИнформациюСтудента(ВыборкаДетальныеЗаписи));			
		        	ИначеЕсли Не ВыборкаДетальныеЗаписи.РезультатТестирования = ПравильныйРезультат И ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.РезультатТестирования) Тогда	
					МассивНеПолностьюСдСтудентов.Добавить(ПолучитьСписокИнформациюСтудента(ВыборкаДетальныеЗаписи));
				Иначе				
					Структура = Новый Структура;
					Структура.Вставить("Студент",ВыборкаДетальныеЗаписи.Студент);
					Структура.Вставить("Группа",ВыборкаДетальныеЗаписи.Группа);
					Структура.Вставить("Тема","");
					Структура.Вставить("Результат","");
					Структура.Вставить("ДатаВыполнения","");
					МассивНеСдСтудентов.Добавить(Структура);
				КонецЕсли; 
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	//Шапка
	ВыводГлавнойШапки(ТабличныйДокумент, ОбластьШапки1,ОбластьОтборСтудент,ОбластьОтборТема, ПараметрыОтчета);
	
	//Вывод таблицы Сдавших практику
	Если ПараметрыОтчета.Практика = "Сдана"  ИЛИ ПараметрыОтчета.Практика = "Все"  Тогда
		Если Не МассивПолностьюСдСтудентов.Количество() = 0 тогда                                                                                              	
			ВыводСтрокиСдавших(МассивПолностьюСдСтудентов,ТабличныйДокумент,ОбластьПодвал,ОбластьСтрока,ОбластьШапкаТбСд, ПараметрыОтчета);	
		КонецЕсли;
	КонецЕсли;		
		
	//Вывод таблицы Не Полностью Сдавших практику  
	Если ПараметрыОтчета.Практика = "НеДоКонца"  ИЛИ ПараметрыОтчета.Практика = "Все"  Тогда
		Если Не МассивНеПолностьюСдСтудентов.Количество() = 0 Тогда
			ВыводСтрокиНеПлСдавших(МассивНеПолностьюСдСтудентов,ТабличныйДокумент,ОбластьПодвал,ОбластьСтрока,ОбластьШапкаТбНДСд,ПараметрыОтчета);	
		КонецЕсли;
	КонецЕсли;
	
	//Вывод таблицы Не Сдавших практику
	Если ПараметрыОтчета.Практика = "Несдана"  ИЛИ ПараметрыОтчета.Практика = "Все"  Тогда
		Если НЕ МассивНеСдСтудентов.Количество() =  0 Тогда
			ВыводСтрокНеСдавших(МассивНеСдСтудентов,ТабличныйДокумент,ОбластьПодвал,ОбластьСтрокаНеСдавших,ОбластьШапкаТбНеСд,ПараметрыОтчета);		
		КонецЕсли;
	КонецЕсли;
	

	Возврат ТабличныйДокумент
КонецФункции


&НаКлиенте
Процедура СтудентПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Элементы.Студент.ТекстРедактирования) тогда
		Объект.Группа = ПолучитьСтудента();	
    		Элементы.Группа.Доступность = Ложь;
	Иначе
		Элементы.Группа.Доступность = Истина;		
	КонецЕсли;		
КонецПроцедуры

Функция ПолучитьСтудента()
	Группа = Объект.Студент.Родитель.Ссылка.Наименование; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Группы.Ссылка КАК Ссылка,
		|	Группы.Наименование КАК Наименование
		|ИЗ
		|	Справочник.Группы КАК Группы
		|ГДЕ
		|	Группы.Наименование = &Наименование";
	Запрос.УстановитьПараметр("Наименование",Группа);
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.Ссылка;		
	КонецЕсли;

КонецФункции

&НаКлиенте
Процедура ПрактикаПриИзменении(Элемент)
	Если Объект.Практика = "Несдана" Тогда
		Элементы.Тема.Доступность = Ложь;
		Объект.Тема = "";
	Иначе 
		Элементы.Тема.Доступность = Истина;	
	КонецЕсли;
КонецПроцедуры  


&НаКлиенте
Процедура ОткрытьWebHelp(Команда)
	ЗапуститьПриложение("http://88.205.135.82:7071/testerRJ45/");
КонецПроцедуры





