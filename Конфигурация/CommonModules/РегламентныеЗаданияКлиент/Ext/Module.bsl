﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// См. ОбщегоНазначенияКлиентПереопределяемый.ПриНачалеРаботыСистемы.
Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	
	ПараметрыРаботыКлиентаПриЗапуске = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыРаботыКлиентаПриЗапуске.ПоказатьФормуБлокировкиРаботыСВнешнимиРесурсами Тогда
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения("ПоказатьФормуБлокировкиРаботыСВнешнимиРесурсами", ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры
	
// Только для внутреннего использования.
Процедура ПоказатьФормуБлокировкиРаботыСВнешнимиРесурсами(Параметры, ДополнительныеПараметры) Экспорт
	
	ПараметрыФормы = Новый Структура("ПринятиеРешенияОБлокировке", Истина);
	Оповещение = Новый ОписаниеОповещения("ПослеОткрытияОкнаБлокировкиРаботыСВнешнимиРесурсами", ЭтотОбъект, Параметры);
	ОткрытьФорму("ОбщаяФорма.БлокировкаРаботыСВнешнимиРесурсами", ПараметрыФормы,,,,, Оповещение);
	
КонецПроцедуры

// Только для внутреннего использования.
Процедура ПослеОткрытияОкнаБлокировкиРаботыСВнешнимиРесурсами(Результат, Параметры) Экспорт
	
	ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
	
КонецПроцедуры

Процедура ПерейтиКНастройкеРегламентныхЗаданий() Экспорт
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("e1cib/app/Обработка.РегламентныеИФоновыеЗадания");
КонецПроцедуры

#КонецОбласти