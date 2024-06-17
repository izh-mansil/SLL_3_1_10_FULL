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
	
	Имя = Параметры.Имя;
	Отчество = Параметры.Отчество;
	ИмяИОтчество = Параметры.Имя + ?(ЗначениеЗаполнено(Параметры.Отчество)," " + Параметры.Отчество, "");
	НовоеИмяИОтчество = ИмяИОтчество;
	Элементы.НовоеИмяИОтчество.ЦветТекста = WebЦвета.Зеленый;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИмяПриИзменении(Элемент)
	УстановитьЦветНадписиИмяИОтчество();
КонецПроцедуры

&НаКлиенте
Процедура ОтчествоПриИзменении(Элемент)
	УстановитьЦветНадписиИмяИОтчество();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если НовоеИмяИОтчество = ИмяИОтчество Тогда
		Закрыть(Новый Структура("Имя, Отчество", СокрП(Имя), СокрП(Отчество)));
	Иначе
		ПоказатьПредупреждение( , СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Имя и отчество должны быть равны %1'"), ИмяИОтчество));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьЦветНадписиИмяИОтчество()
	
	НовоеИмяИОтчество = СокрП(Имя) + ?(ПустаяСтрока(Отчество), "", " " + СокрП(Отчество));
	Если НовоеИмяИОтчество = ИмяИОтчество Тогда
		Элементы.НовоеИмяИОтчество.ЦветТекста = WebЦвета.Зеленый;
	Иначе
		Элементы.НовоеИмяИОтчество.ЦветТекста = WebЦвета.Красный;
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти
