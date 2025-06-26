#include "Base_Hook.h"

#include <algorithm>

#define EMU_OVERLAY // NOTE: REMOVE THIS LINE FOR PRODUCTION BUILD

#ifdef EMU_OVERLAY
#ifdef STEAM_WIN32

#include "../detours/detours.h"

Base_Hook::Base_Hook():
    _library(nullptr)
{}

Base_Hook::~Base_Hook()
{
    UnhookAll();
}

const char* Base_Hook::get_lib_name() const
{
    return "<no_name>";
}

void Base_Hook::BeginHook()
{
    DetourTransactionBegin();
    DetourUpdateThread(GetCurrentThread());
}

void Base_Hook::EndHook()
{
    DetourTransactionCommit();
}

void Base_Hook::HookFunc(std::pair<void**, void*> hook)
{
    if( DetourAttach(hook.first, hook.second) == 0 )
        _hooked_funcs.emplace_back(hook);
}

void Base_Hook::UnhookAll()
{
    if (_hooked_funcs.size())
    {
        BeginHook();
        std::for_each(_hooked_funcs.begin(), _hooked_funcs.end(), [](std::pair<void**, void*>& hook) {
            DetourDetach(hook.first, hook.second);
            });
        EndHook();
        _hooked_funcs.clear();
    }
}

#elif defined(__linux__)

#include "frida-gum.h"

Base_Hook::Base_Hook():
    _library(nullptr)
{
    gum_init_embedded();
    _interceptor = gum_interceptor_obtain();
}

Base_Hook::~Base_Hook()
{
    UnhookAll();
    gum_deinit_embedded();
}

const char* Base_Hook::get_lib_name() const
{
    return "<no_name>";
}

void Base_Hook::BeginHook()
{
    gum_interceptor_begin_transaction (_interceptor);
}

void Base_Hook::EndHook()
{
    gum_interceptor_end_transaction (_interceptor);
}

void Base_Hook::HookFunc(std::pair<void**, void*> hook)
{
    PRINT_DEBUG("Hooking function: %p -> %p\n", (void*)*hook.first, hook.second);
    gum_interceptor_replace_fast(_interceptor, *hook.first, hook.second, NULL);
    _hooked_funcs.emplace_back(hook);
}

void Base_Hook::UnhookAll()
{
    if (_hooked_funcs.size())
    {
        BeginHook();
        std::for_each(_hooked_funcs.begin(), _hooked_funcs.end(), [this](std::pair<void**, void*>& hook) {
            gum_interceptor_revert(_interceptor, *hook.first);
            });
        _hooked_funcs.clear();
        EndHook();
    }
}

#endif

#endif//EMU_OVERLAY
