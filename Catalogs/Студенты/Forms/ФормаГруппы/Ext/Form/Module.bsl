
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	СозданиеГруппа();
КонецПроцедуры     

&НаСервере
Процедура СозданиеГруппа() 
	НаименованиеНовойГруппы 	=  Объект.Наименование;
	СуществующаяГруппа			= Справочники.Группы.НайтиПоНаименованию(НаименованиеНовойГруппы);
	Если НЕ ЗначениеЗаполнено(СуществующаяГруппа) тогда
		Группы = Справочники.Группы.СоздатьЭлемент();
		Группы.Наименование = Объект.Наименование;
		Группы.Записать();	
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция  ПолучитьГруппу(Наименование)

	Возврат Справочники.Студенты.НайтиПоНаименованию(Наименование) 

КонецФункции // ()


&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Группа = ПолучитьГруппу(Объект.Наименование);
	Если ЗначениеЗаполнено(Группа) Тогда 
		Предупреждение("Группа '" + Объект.Наименование + "' уже сужествует");
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры
