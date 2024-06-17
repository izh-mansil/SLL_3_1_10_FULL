﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Позволяет внести изменения в дерево с разделами полнотекстового поиска, отображаемое при выборе области поиска.
// По умолчанию дерево разделов формируется на основании состава подсистем конфигурации.
//
// Перед добавлением объекта метаданных убедитесь, что его свойство ПолнотекстовыйПоиск
// установлено в значение Метаданные.СвойстваОбъектов.ИспользованиеПолнотекстовогоПоиска.Использовать.
//
// Параметры:
//   РазделыПоиска - ДеревоЗначений - области поиска. Содержит колонки:
//     * Раздел   - Строка   - представление раздела, например, название подсистемы или объекта метаданных.
//     * Картинка - Картинка - картинка раздела, рекомендуется только для корневых разделов.
//     * ОбъектМД - СправочникСсылка.ИдентификаторыОбъектовМетаданных,
//                  СправочникСсылка.ИдентификаторыОбъектовРасширений - задается только для объектов метаданных, для
//                                                                      разделов остается пустым.
// Пример:
//
//	РазделГлавное = РазделыПоиска.Строки.Добавить();
//	РазделГлавное.Раздел = "Главное";
//	РазделГлавное.Картинка = БиблиотекаКартинок.РазделГлавное;
//	
//	СчетНаОплату = Метаданные.Документы._ДемоСчетНаОплатуПокупателю;
//	Если ПравоДоступа("Просмотр", СчетНаОплату)
//		И ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(СчетНаОплату) Тогда 
//		
//		ОбъектРаздела = РазделГлавное.Строки.Добавить();
//		ОбъектРаздела.Раздел = СчетНаОплату.ПредставлениеСписка;
//		ОбъектРаздела.ОбъектМД = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(СчетНаОплату);
//	КонецЕсли;
//
Процедура ПриПолученииРазделовПолнотекстовогоПоиска(РазделыПоиска) Экспорт
	
	// _Демо начало примера
	
	// Добавление раздела "Главное".
	РазделГлавное = РазделыПоиска.Строки.Добавить();
	РазделГлавное.Раздел = НСтр("ru = 'Главное'");
	РазделГлавное.Картинка = БиблиотекаКартинок._ДемоРазделГлавное;
	
	// Пример документа
	ОбъектМетаданных = Метаданные.Документы._ДемоСчетНаОплатуПокупателю;
	Если ПравоДоступа("Просмотр", ОбъектМетаданных)
		И ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(ОбъектМетаданных) Тогда 
		
		ОбъектРаздела = РазделГлавное.Строки.Добавить();
		ОбъектРаздела.Раздел = ОбщегоНазначения.ПредставлениеСписка(ОбъектМетаданных);
		ОбъектРаздела.ОбъектМД = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ОбъектМетаданных);
	КонецЕсли;

	// Пример справочника с подчиненными справочниками
	ОбъектМетаданных = Метаданные.Справочники._ДемоПартнеры;
	Если ПравоДоступа("Просмотр", ОбъектМетаданных)
		И ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(ОбъектМетаданных) Тогда 
		
		ОбъектРаздела = РазделГлавное.Строки.Добавить();
		ОбъектРаздела.Раздел = ОбщегоНазначения.ПредставлениеСписка(ОбъектМетаданных);
		ОбъектРаздела.ОбъектМД = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ОбъектМетаданных);
	КонецЕсли;

	// Пример журнала документов
	ОбъектМетаданных = Метаданные.ЖурналыДокументов.Взаимодействия;
	Если ПравоДоступа("Просмотр", ОбъектМетаданных)
		И ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(ОбъектМетаданных) Тогда 
		
		ОбъектРаздела = РазделГлавное.Строки.Добавить();
		ОбъектРаздела.Раздел = ОбщегоНазначения.ПредставлениеСписка(ОбъектМетаданных);
		ОбъектРаздела.ОбъектМД = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ОбъектМетаданных);
	КонецЕсли;
	// _Демо конец примера
	
КонецПроцедуры

#КонецОбласти