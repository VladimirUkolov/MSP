﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Файл = Параметры.ФайлСсылка;
	КомментарийКВерсии = Параметры.КомментарийКВерсии;
	СоздатьНовуюВерсию = Параметры.СоздатьНовуюВерсию;
	
	Если Файл.ХранитьВерсии Тогда
		СоздатьНовуюВерсию = Истина;
		Элементы.СоздатьНовуюВерсию.Доступность = Параметры.СоздатьНовуюВерсиюДоступность;
		Если Не Параметры.СоздатьНовуюВерсиюДоступность Тогда
			Элементы.СоздатьНовуюВерсию.Подсказка = НСтр("ru = 'Настройка сохранения версии присоединенного файла задана его автором и не может быть изменена.'");
			Элементы.СоздатьНовуюВерсию.ОтображениеПодсказки = ОтображениеПодсказки.Кнопка;
		КонецЕсли;
	Иначе
		СоздатьНовуюВерсию = Ложь;
		Элементы.СоздатьНовуюВерсию.Доступность = Ложь;
		Элементы.СоздатьНовуюВерсию.Подсказка = НСтр("ru = 'Версии для этого присоединенного файла отключены.'");
		Элементы.СоздатьНовуюВерсию.ОтображениеПодсказки = ОтображениеПодсказки.Кнопка;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	СтруктураВозврата = Новый Структура("КомментарийКВерсии, СоздатьНовуюВерсию, КодВозврата",
		КомментарийКВерсии, СоздатьНовуюВерсию, КодВозвратаДиалога.ОК);
	
	Закрыть(СтруктураВозврата);
	
	Оповестить("РаботаСФайлами_ЗаписанаНоваяВерсияФайла");
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	СтруктураВозврата = Новый Структура("КомментарийКВерсии, СоздатьНовуюВерсию, КодВозврата",
		КомментарийКВерсии, СоздатьНовуюВерсию, КодВозвратаДиалога.Отмена);
	
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

#КонецОбласти