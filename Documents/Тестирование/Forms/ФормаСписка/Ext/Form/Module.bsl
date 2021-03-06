
&НаКлиенте
Процедура СформироватьОтчет(Команда)
	ОткрытьФормуМодально("Отчет.ОтчетПоРезультатамТестирования.Форма.Настройка");
КонецПроцедуры

&НаКлиенте
Процедура ЭкспортCSV(Команда) 
	Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.Заголовок = "Выберите путь";
	Если ДиалогОткрытияФайла.Выбрать() Тогда
	    	ПутьККаталогу = ДиалогОткрытияФайла.Каталог;
	    	ЭкспортДанных.ЭкспортТестированиеCSVНаСервере(ПутьККаталогу);  
		Сообщить("Экспорт завершен");
	КонецЕсли;  

КонецПроцедуры

&НаКлиенте
Процедура Импорт(Команда) 
	Режим = РежимДиалогаВыбораФайла.Открытие;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	Фильтр = "(*.csv)|*.csv";
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	Если ДиалогОткрытияФайла.Выбрать() Тогда
	   	Файл = ДиалогОткрытияФайла.ВыбранныеФайлы[0];
		ИмпортДанных.ИмпортТестированиеНаСервере(Файл);
	    	Сообщить("Импорт завершен");	
	КонецЕсли;
КонецПроцедуры



&НаКлиенте
Процедура ОткрытьWebHelp(Команда)
	ЗапуститьПриложение("http://88.205.135.82:7071/testerRJ45/");
КонецПроцедуры