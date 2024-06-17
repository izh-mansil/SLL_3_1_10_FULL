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
	
	ОбработатьПереданныеПараметры();
	
	УстановитьПредопределенныеОтборы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	ПриИзмененииВладельцаНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецОчистка(Элемент, СтандартнаяОбработка)
	
	ПриИзмененииВладельцаНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбработатьПереданныеПараметры()
	
	Если Параметры.Отбор.Свойство("Владелец")
		И ЗначениеЗаполнено(Параметры.Отбор.Владелец) Тогда
		
		Владелец = Параметры.Отбор.Владелец;
		Элементы.Владелец.Видимость = Ложь;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Владелец) Тогда
		Владелец = РаботаСПочтовымиСообщениями.СистемнаяУчетнаяЗапись();
		ПриИзмененииВладельцаНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПредопределенныеОтборы()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
	                                                                        "ПометкаУдаления",
	                                                                        Ложь,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        НСтр("ru = 'Отображение только не помеченных на удаление папок'"),
	                                                                        Истина, 
	                                                                        РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииВладельцаНаСервере()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
	                                                                        "Владелец",
	                                                                        Владелец,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        НСтр("ru = 'Отбор по владельцу папок'"),
	                                                                        ЗначениеЗаполнено(Владелец), 
	                                                                        РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
	
КонецПроцедуры

#КонецОбласти