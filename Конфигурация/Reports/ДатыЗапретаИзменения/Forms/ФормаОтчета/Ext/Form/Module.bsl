﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьВариантНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПервыйВариант(Команда)
	
	УстановитьВариантНаСервере(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ВторойВариант(Команда)
	
	УстановитьВариантНаСервере(2);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВариантНаСервере(Вариант = 0)
	
	Отчеты.ДатыЗапретаИзменения.УстановитьВариант(ЭтотОбъект, Вариант);
	
КонецПроцедуры

#КонецОбласти
