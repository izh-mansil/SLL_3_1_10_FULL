﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Взаимодействия.РассчитыватьРассмотрено(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	КонтактыВзаимодействий.Контакт
	|ИЗ
	|	РегистрСведений.КонтактыВзаимодействий КАК КонтактыВзаимодействий
	|ГДЕ
	|	КонтактыВзаимодействий.Взаимодействие = &Взаимодействие";
	
	Запрос.УстановитьПараметр("Взаимодействие", Отбор.Взаимодействие.Значение);
	ДополнительныеСвойства.Вставить("ТаблицаЗаписи",  Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Взаимодействия.РассчитыватьРассмотрено(ДополнительныеСвойства) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	СтарыйНабор.Контакт КАК Контакт
	|ПОМЕСТИТЬ СтарыйНабор
	|ИЗ
	|	&СтарыйНабор КАК СтарыйНабор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КонтактыВзаимодействий.Контакт КАК Контакт
	|ПОМЕСТИТЬ НовыйНабор
	|ИЗ
	|	РегистрСведений.КонтактыВзаимодействий КАК КонтактыВзаимодействий
	|ГДЕ
	|	КонтактыВзаимодействий.Взаимодействие = &Взаимодействие
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Контакт
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НовыйНабор.Контакт КАК ПоЧемуРассчитывать
	|ИЗ
	|	НовыйНабор КАК НовыйНабор
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	СтарыйНабор.Контакт
	|ИЗ
	|	СтарыйНабор КАК СтарыйНабор";
	
	Запрос.УстановитьПараметр("СтарыйНабор", ДополнительныеСвойства.ТаблицаЗаписи);
	Запрос.УстановитьПараметр("Взаимодействие", Отбор.Взаимодействие.Значение);
	Взаимодействия.РассчитатьРассмотреноПоКонтактам(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли