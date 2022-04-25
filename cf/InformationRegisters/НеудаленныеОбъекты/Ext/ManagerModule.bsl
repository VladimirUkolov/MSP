﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Формирует таблицу с количеством попыток для указанных объектов.
// Если объект ранее не удалялся, то запись о количестве попыток будет отсутствовать.
// 
// Параметры:
//   Объекты - Массив из ЛюбаяСсылка
// Возвращаемое значение:
//   ТаблицаЗначений:
//   * УдаляемыйСсылка - ЛюбаяСсылка
//   * КоличествоПопыток - Число
//
Функция КоличествоПопытокОбъектов(Объекты) Экспорт
	Запрос = Новый Запрос;
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НеудаленныеОбъекты.Объект КАК УдаляемыйСсылка,
		|	НеудаленныеОбъекты.КоличествоПопыток КАК КоличествоПопыток
		|ИЗ
		|	РегистрСведений.НеудаленныеОбъекты КАК НеудаленныеОбъекты
		|ГДЕ
		|	НеудаленныеОбъекты.Объект В (&СписокОбъектов)
		|	И НеудаленныеОбъекты.КоличествоПопыток > 0";
	
	Запрос.УстановитьПараметр("СписокОбъектов", Объекты);
	
	РезультатЗапроса = Запрос.Выполнить();
	КоличествоПопытокОбъектов = РезультатЗапроса.Выгрузить();
	КоличествоПопытокОбъектов.Индексы.Добавить("УдаляемыйСсылка");
	
	Возврат КоличествоПопытокОбъектов;
КонецФункции

// Добавляет запись в регистр.
// 
// Параметры:
//   НеудаленнаяСсылка - ЛюбаяСсылка
//
Процедура Добавить(НеудаленнаяСсылка) Экспорт
	Запись = РегистрыСведений.НеудаленныеОбъекты.СоздатьМенеджерЗаписи();
	Запись.Объект = НеудаленнаяСсылка;
	Если ЗначениеЗаполнено(Запись.Объект) Тогда
		Запись.Записать();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли