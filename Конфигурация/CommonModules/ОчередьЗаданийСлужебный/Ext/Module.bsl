﻿// @strict-types

#Область СлужебныйПрограммныйИнтерфейс

// Обработчик регламентного задания УдалитьОбработкаОчередиЗаданийБТС.
//
// Параметры:
//	ПараметрыЗадания - СправочникСсылка.ОбработчикиОчередиЗаданий - параметры задания.
//
Процедура ОбработкаОчередиЗаданийБТС(ПараметрыЗадания) Экспорт
	
	ВызватьИсключение НСтр("ru = 'Процедура не используется'");
	
КонецПроцедуры

// Производит планирование выполнения заданий из РС ОчередьЗаданий.
// @skip-check module-empty-method - особенность реализации.
// 
Процедура ПланированиеОбработкиЗаданий() Экспорт
	
КонецПроцедуры

// Процедура выполняет задание из справочника ОчередьЗаданий.
// @skip-check module-empty-method - особенность реализации. 
// 
// Параметры: 
//  ПараметрыЗадания - Структура - параметры необходимые для выполнения задания
//
Процедура РегламентнаяОбработкаОчередиЗаданий(ПараметрыЗадания) Экспорт
	
КонецПроцедуры

// Возвращает возможные методы для использования в очереди заданий.
// Возвращаемое значение:
//	Массив из Строка - массив имен методов.
Функция ВозможныеМетоды() Экспорт
	
	Возврат Новый Массив;
	
КонецФункции

// См. РаботаВМоделиСервисаПереопределяемый.ПриВключенииРазделенияПоОбластямДанных.
// @skip-check module-empty-method - особенность реализации.
//
Процедура ПриВключенииРазделенияПоОбластямДанных() Экспорт
	
КонецПроцедуры

// См. ЗагрузкаДанныхИзФайлаПереопределяемый.ПриОпределенииСправочниковДляЗагрузкиДанных
// @skip-check module-empty-method - особенность реализации.
//
// Параметры:
//	ЗагружаемыеСправочники - ТаблицаЗначений -
//
Процедура ПриОпределенииСправочниковДляЗагрузкиДанных(ЗагружаемыеСправочники) Экспорт
	
КонецПроцедуры

// См. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления.
// @skip-check module-empty-method - особенность реализации.
//
// Параметры:
//	Обработчики - см. ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
КонецПроцедуры

// Обработчик регламентного задания ЗапускОбработкиЗаданий.
// @skip-check module-empty-method - особенность реализации.
//
Процедура ЗапускОбработкиЗаданий() Экспорт
	
КонецПроцедуры


#КонецОбласти
