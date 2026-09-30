// Copyright (C) 2002-2012 Nikolaus Gebhardt
// Modified by Mustapha T.
// This file is part of the "Irrlicht Engine".
// For conditions of distribution and use, see copyright notice in irrlicht.h

#include "guiEditBoxWithScrollbar.h"

#include "IGUISkin.h"
#include "IGUIEnvironment.h"
#include "IGUIFont.h"
#include "rect.h"

#include "guiScrollBar.h"
#include "client/renderingengine.h"

using namespace gui;

//! constructor
GUIEditBoxWithScrollBar::GUIEditBoxWithScrollBar(const wchar_t* text, bool border,
	IGUIEnvironment* environment, IGUIElement* parent, s32 id,
	const core::rect<s32>& rectangle, ISimpleTextureSource *tsrc,
	bool writable, bool has_vscrollbar)
	: CGUIEditBox(text, border, environment, parent, id, rectangle),
	m_bg_color_used(false), m_tsrc(tsrc)
{
	if (has_vscrollbar) {
		createVScrollBar();

		calculateFrameRect();
		breakText();

		calculateScrollPos();
	}
	setWritable(writable);
}

//! draws the element and its children
void GUIEditBoxWithScrollBar::draw()
{
	if (!IsVisible)
		return;

	IGUISkin *skin = Environment->getSkin();
	if (!skin)
		return;

	if (m_bg_color_used) {
		OverrideBgColor = m_bg_color;
	} else if (IsWritable) {
		OverrideBgColor = skin->getColor(EGDC_WINDOW);
	} else {
		// Transparent
		OverrideBgColor = 0x00000001;
	}

	CGUIEditBox::draw();
}

bool GUIEditBoxWithScrollBar::OnEvent(const SEvent &event)
{
	if (event.EventType == EET_MOUSE_INPUT_EVENT && VScrollBar &&
			VScrollBar->isVisible() && event.MouseInput.Simulated) {
		core::position2d<s32> pos(event.MouseInput.X, event.MouseInput.Y);

		if (event.MouseInput.Event == EMIE_LMOUSE_PRESSED_DOWN) {
			if (AbsoluteRect.isPointInside(pos) &&
					VScrollBar->getMax() > VScrollBar->getMin()) {
				m_swipe_start_y = event.MouseInput.Y + VScrollBar->getPos();
			}
		} else if (event.MouseInput.Event == EMIE_LMOUSE_LEFT_UP) {
			m_swipe_start_y = -1;
			if (m_swipe_started) {
				m_swipe_started = false;
				return true;
			}
		} else if (event.MouseInput.Event == EMIE_MOUSE_MOVED &&
				m_swipe_start_y != -1) {
			double screen_dpi = RenderingEngine::getDisplayDensity() * 96;

			if (!m_swipe_started &&
					std::abs(m_swipe_start_y - event.MouseInput.Y -
							VScrollBar->getPos()) >
							0.1 * screen_dpi) {
				m_swipe_started = true;
				Environment->setFocus(this);
			}

			if (m_swipe_started) {
				m_swipe_pos = (float)(m_swipe_start_y - event.MouseInput.Y);
				VScrollBar->setPos((s32)m_swipe_pos);
				return true;
			}
		}
	}

	return CGUIEditBox::OnEvent(event);
}

//! create a vertical scroll bar
void GUIEditBoxWithScrollBar::createVScrollBar()
{
	IGUISkin *skin = 0;
	if (Environment)
		skin = Environment->getSkin();
	if (!skin || VScrollBar)
		return;

	s32 fontHeight = 1;

	if (OverrideFont) {
		fontHeight = OverrideFont->getDimension(L"Ay").Height;
	} else {
		IGUIFont *font;
		if ((font = skin->getFont())) {
			fontHeight = font->getDimension(L"Ay").Height;
		}
	}

	VScrollBarWidth = skin->getSize(gui::EGDS_SCROLLBAR_SIZE);

	core::rect<s32> scrollbarrect = RelativeRect;
	scrollbarrect.UpperLeftCorner.X += RelativeRect.getWidth() - VScrollBarWidth;
	VScrollBar = new GUIScrollBar(Environment, getParent(), -1,
			scrollbarrect, false, m_tsrc);

	VScrollBar->setVisible(false);
	VScrollBar->setSmallStep(3 * fontHeight);
	VScrollBar->setLargeStep(10 * fontHeight);
}

//! Change the background color
void GUIEditBoxWithScrollBar::setBackgroundColor(const video::SColor &bg_color)
{
	m_bg_color = bg_color;
	m_bg_color_used = true;
}
