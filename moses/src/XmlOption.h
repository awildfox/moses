#pragma once

#include <vector>
#include <string>
#include "InputType.h"

namespace Moses
{

class TranslationOption;

/** This struct is used for storing XML force translation data for a given range in the sentence
 */
struct XmlOption {

	size_t startPos, endPos;
	std::vector<std::string> targetPhrases;
	std::vector<float> targetScores;

	XmlOption(int s, int e, std::string targetPhrase, float targetScore): startPos(s), endPos(e) {
		targetPhrases.push_back(targetPhrase);
		targetScores.push_back(targetScore);
	}

};

std::vector<TranslationOption*> ProcessAndStripXMLTags(std::string& line, const InputType &source);

}


