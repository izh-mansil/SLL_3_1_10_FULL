﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Одинаковые процедуры и функции форм ДатыЗапретаИзменения и РедактированиеДатыЗапрета.

Функция ОписанияДатЗапрета() Экспорт
	
	Список = Новый Соответствие;
	Список.Вставить("",                      НСтр("ru = 'Не установлена'"));
	Список.Вставить("ПроизвольнаяДата",      НСтр("ru = 'Произвольная дата'"));
	Список.Вставить("КонецПрошлогоГода",     НСтр("ru = 'Конец прошлого года'"));
	Список.Вставить("КонецПрошлогоКвартала", НСтр("ru = 'Конец прошлого квартала'"));
	Список.Вставить("КонецПрошлогоМесяца",   НСтр("ru = 'Конец прошлого месяца'"));
	Список.Вставить("КонецПрошлойНедели",    НСтр("ru = 'Конец прошлой недели'"));
	Список.Вставить("ПредыдущийДень",        НСтр("ru = 'Предыдущий день'"));
	
	Возврат Список;
	
КонецФункции

Процедура УточнитьНастройкуДатыЗапретаПриИзменении(Контекст, РассчитатьДатуЗапрета = Истина) Экспорт
	
	Если Не Контекст.ВыбранРасширенныйРежим Тогда
		Если Контекст.ДатаЗапрета <> '00010101' И Контекст.ОписаниеДатыЗапрета = "" Тогда
			Контекст.ОписаниеДатыЗапрета = "ПроизвольнаяДата";
			
		ИначеЕсли Контекст.ДатаЗапрета = '00010101'
		        И Контекст.ОписаниеДатыЗапрета = "ПроизвольнаяДата"
		        И Не Контекст.ЗаписьСуществует Тогда
			
			Контекст.ОписаниеДатыЗапрета = "";
		КонецЕсли;
	КонецЕсли;
	Если Контекст.ОписаниеДатыЗапрета = "" Тогда
		Контекст.ДатаЗапрета = "00010101";
	КонецЕсли;
	
	Контекст.ТекстНадписиОтносительнойДатыЗапрета = "";
	
	Если Контекст.ОписаниеДатыЗапрета = "ПроизвольнаяДата" Или Контекст.ОписаниеДатыЗапрета = "" Тогда
		Контекст.КоличествоДнейРазрешения = 0;
		Возврат;
	КонецЕсли;
	
	РасчетныеДатыЗапрета = РасчетДатыЗапрета(
		Контекст.ОписаниеДатыЗапрета, Контекст.НачалоДня);
	
	Если РассчитатьДатуЗапрета Тогда
		Контекст.ДатаЗапрета = РасчетныеДатыЗапрета.Текущая;
	КонецЕсли;
	
	ТекстНадписи = "";
	
	Если Контекст.РазрешитьИзменениеДанныхДоДатыЗапрета Тогда
		Сутки = 60*60*24;
		
		СкорректироватьКоличествоДнейРазрешения(
			Контекст.ОписаниеДатыЗапрета, Контекст.КоличествоДнейРазрешения);
		
		СрокРазрешения = РасчетныеДатыЗапрета.Текущая + Контекст.КоличествоДнейРазрешения * Сутки;
		
		Если Контекст.НачалоДня > СрокРазрешения Тогда
			ТекстНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Запрещен ввод и редактирование данных за все прошлые периоды 
					|по %1 включительно (%2).
					|Отсрочка, разрешавшая ввод и редактирование данных 
					|за период с %3 по %4, истекла %5.'"),
				Формат(Контекст.ДатаЗапрета, "ДЛФ=Д"), НРег(ОписанияДатЗапрета()[Контекст.ОписаниеДатыЗапрета]),
				Формат(РасчетныеДатыЗапрета.Предыдущая + Сутки, "ДЛФ=Д"), Формат(РасчетныеДатыЗапрета.Текущая, "ДЛФ=Д"),
				Формат(СрокРазрешения, "ДЛФ=Д"));
		Иначе
			Если РассчитатьДатуЗапрета Тогда
				Контекст.ДатаЗапрета = РасчетныеДатыЗапрета.Предыдущая;
			КонецЕсли;
			ТекстНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '• По %1 включительно запрещен ввод и редактирование данных
					|  за все прошлые периоды по %2
					|  и действует отсрочка, разрешающая ввод и редактирование данных 
					|  за период с %4 по %5;
					|• С %6 начнет действовать запрет на ввод и редактирование данных
					|  за все прошлые периоды по %5 (%3).'"),
					Формат(СрокРазрешения, "ДЛФ=Д"), Формат(Контекст.ДатаЗапрета, "ДЛФ=Д"), НРег(ОписанияДатЗапрета()[Контекст.ОписаниеДатыЗапрета]),
					Формат(РасчетныеДатыЗапрета.Предыдущая + Сутки, "ДЛФ=Д"),  Формат(РасчетныеДатыЗапрета.Текущая, "ДЛФ=Д"), 
					Формат(СрокРазрешения + Сутки, "ДЛФ=Д"));
		КонецЕсли;
	Иначе 
		Контекст.КоличествоДнейРазрешения = 0;
		ТекстНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Запрещен ввод и редактирование данных за все прошлые периоды
			           |по %1 (%2)'"),
			Формат(Контекст.ДатаЗапрета, "ДЛФ=Д"), НРег(ОписанияДатЗапрета()[Контекст.ОписаниеДатыЗапрета]));
	КонецЕсли;
	
	Контекст.ТекстНадписиОтносительнойДатыЗапрета = ТекстНадписи;
	
КонецПроцедуры

// Параметры:
//  Контекст - ФормаКлиентскогоПриложения:
//    * Элементы - ВсеЭлементыФормы:
//       ** РазрешитьИзменениеДанныхДоДатыЗапрета - ПолеФормы
//       ** КоличествоДнейРазрешения - ПолеФормы
//       ** ПояснениеНепроизвольнойДаты - ПолеФормы
// 
Процедура ОбновитьОтображениеДатыЗапретаПриИзменении(Контекст) Экспорт
	
	Если Не Контекст.ВыбранРасширенныйРежим Тогда
		
		Если Контекст.ОписаниеДатыЗапрета = "" Или Контекст.ОписаниеДатыЗапрета = "ПроизвольнаяДата" Тогда
			Контекст.ВыбранРасширенныйРежим = Ложь;
			Контекст.Элементы.РасширенныйРежим.Видимость = Ложь;
			Контекст.Элементы.ГруппаРежимыРаботы.ТекущаяСтраница = Контекст.Элементы.ПростойРежим;
		Иначе
			Контекст.ВыбранРасширенныйРежим = Истина;
			Контекст.Элементы.РасширенныйРежим.Видимость = Истина;
			Контекст.Элементы.ГруппаРежимыРаботы.ТекущаяСтраница = Контекст.Элементы.РасширенныйРежим;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Контекст.ОписаниеДатыЗапрета = "" Или Контекст.ОписаниеДатыЗапрета = "ПроизвольнаяДата" Тогда
		Контекст.Элементы.ПроизвольнаяДата.ТекущаяСтраница = ?(Контекст.ОписаниеДатыЗапрета = "",
			Контекст.Элементы.ПроизвольнаяДатаНеИспользуется, Контекст.Элементы.ПроизвольнаяДатаИспользуется);
		ФорматРедактирования = ?(Контекст.ЗаписьСуществует, "ДП=01.01.0001", "");
		Контекст.Элементы.ДатаЗапретаПростойРежим.ФорматРедактирования = ФорматРедактирования;
		Контекст.Элементы.ДатаЗапрета.ФорматРедактирования = ФорматРедактирования;
		Контекст.Элементы.СвойстваДатыЗапрета.ТекущаяСтраница = Контекст.Элементы.НетПояснения;
		Контекст.Элементы.ДатаЗапретаПростойРежим.ОбновитьТекстРедактирования();
		Контекст.Элементы.ДатаЗапрета.ОбновитьТекстРедактирования();
		Контекст.РазрешитьИзменениеДанныхДоДатыЗапрета = Ложь;
		Возврат;
	КонецЕсли;
	
	Контекст.Элементы.СвойстваДатыЗапрета.ТекущаяСтраница = Контекст.Элементы.ОтносительнаяДата;
	Контекст.Элементы.ПроизвольнаяДата.ТекущаяСтраница = Контекст.Элементы.ПроизвольнаяДатаНеИспользуется;
	
	Если Контекст.ОписаниеДатыЗапрета = "ПредыдущийДень" Тогда
		Контекст.Элементы.РазрешитьИзменениеДанныхДоДатыЗапрета.Доступность = Ложь;
		Контекст.РазрешитьИзменениеДанныхДоДатыЗапрета = Ложь;
	Иначе
		Контекст.Элементы.РазрешитьИзменениеДанныхДоДатыЗапрета.Доступность = Истина;
	КонецЕсли;
	
	Контекст.Элементы.КоличествоДнейРазрешения.Доступность = Контекст.РазрешитьИзменениеДанныхДоДатыЗапрета;
	Контекст.Элементы.ПояснениеНепроизвольнойДаты.Заголовок = Контекст.ТекстНадписиОтносительнойДатыЗапрета;
	
КонецПроцедуры

Функция РасчетДатыЗапрета(Знач ВариантДатыЗапрета, Знач ТекущаяДатаНаСервере)
	
	Сутки = 60*60*24;
	
	ТекущаяДатаЗапрета    = '00010101';
	ПредыдущаяДатаЗапрета = '00010101';
	
	Если ВариантДатыЗапрета = "КонецПрошлогоГода" Тогда
		ТекущаяДатаЗапрета    = НачалоГода(ТекущаяДатаНаСервере) - Сутки;
		ПредыдущаяДатаЗапрета = НачалоГода(ТекущаяДатаЗапрета)   - Сутки;
		
	ИначеЕсли ВариантДатыЗапрета = "КонецПрошлогоКвартала" Тогда
		ТекущаяДатаЗапрета    = НачалоКвартала(ТекущаяДатаНаСервере) - Сутки;
		ПредыдущаяДатаЗапрета = НачалоКвартала(ТекущаяДатаЗапрета)   - Сутки;
		
	ИначеЕсли ВариантДатыЗапрета = "КонецПрошлогоМесяца" Тогда
		ТекущаяДатаЗапрета    = НачалоМесяца(ТекущаяДатаНаСервере) - Сутки;
		ПредыдущаяДатаЗапрета = НачалоМесяца(ТекущаяДатаЗапрета)   - Сутки;
		
	ИначеЕсли ВариантДатыЗапрета = "КонецПрошлойНедели" Тогда
		ТекущаяДатаЗапрета    = НачалоНедели(ТекущаяДатаНаСервере) - Сутки;
		ПредыдущаяДатаЗапрета = НачалоНедели(ТекущаяДатаЗапрета)   - Сутки;
		
	ИначеЕсли ВариантДатыЗапрета = "ПредыдущийДень" Тогда
		ТекущаяДатаЗапрета    = НачалоДня(ТекущаяДатаНаСервере) - Сутки;
		ПредыдущаяДатаЗапрета = НачалоДня(ТекущаяДатаЗапрета)   - Сутки;
	КонецЕсли;
	
	Возврат Новый Структура("Текущая, Предыдущая", ТекущаяДатаЗапрета, ПредыдущаяДатаЗапрета);
	
КонецФункции

Процедура СкорректироватьКоличествоДнейРазрешения(Знач ОписаниеДатыЗапрета, КоличествоДнейРазрешения)
	
	Если КоличествоДнейРазрешения = 0 Тогда
		КоличествоДнейРазрешения = 1;
		
	ИначеЕсли ОписаниеДатыЗапрета = "КонецПрошлогоГода" Тогда
		Если КоличествоДнейРазрешения > 90 Тогда
			КоличествоДнейРазрешения = 90;
		КонецЕсли;
		
	ИначеЕсли ОписаниеДатыЗапрета = "КонецПрошлогоКвартала" Тогда
		Если КоличествоДнейРазрешения > 60 Тогда
			КоличествоДнейРазрешения = 60;
		КонецЕсли;
		
	ИначеЕсли ОписаниеДатыЗапрета = "КонецПрошлогоМесяца" Тогда
		Если КоличествоДнейРазрешения > 25 Тогда
			КоличествоДнейРазрешения = 25;
		КонецЕсли;
		
	ИначеЕсли ОписаниеДатыЗапрета = "КонецПрошлойНедели" Тогда
		Если КоличествоДнейРазрешения > 5 Тогда
			КоличествоДнейРазрешения = 5;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
