//package com.construcaosoftware.demo.service;
//
//import com.construcaosoftware.demo.config.UserMapper;
//import com.construcaosoftware.demo.dtos.UserDto;
//import com.construcaosoftware.demo.entity.UserEntity;
//import com.construcaosoftware.demo.repository.UserRepository;
//import org.junit.jupiter.api.BeforeEach;
//import org.junit.jupiter.api.Test;
//import org.junit.jupiter.api.extension.ExtendWith;
//import org.mockito.InjectMocks;
//import org.mockito.Mock;
//import org.mockito.junit.jupiter.MockitoExtension;
//
//import java.time.LocalDate;
//import java.util.NoSuchElementException;
//import java.util.Optional;
//
//import static org.junit.jupiter.api.Assertions.*;
//import static org.mockito.Mockito.*;
//
//@ExtendWith(MockitoExtension.class)
//class UserServiceTest {
//
//    @Mock
//    private UserRepository userRepository;
//
//    @Mock
//    private UserMapper userMapper;
//
//    @InjectMocks
//    private UserService userService;
//
//    private UserDto userDto;
//    private UserEntity userEntity;
//
//    @BeforeEach
//    void setUp() {
//        userDto = new UserDto();
//        userDto.setFirstName("Ana");
//        userDto.setLastName("Silva");
//        userDto.setDocument("12345678900");
//        userDto.setBirthday(String.valueOf(LocalDate.of(1990, 1, 1)));
//        userDto.setEmail("ana@email.com");
//
//        userEntity = new UserEntity();
//        userEntity.setFirstName("Ana");
//        userEntity.setLastName("Silva");
//        userEntity.setDocument("12345678900");
//        userEntity.setBirthday(String.valueOf(LocalDate.of(1990, 1, 1)));
//        userEntity.setEmail("ana@email.com");
//    }
//
//    @Test
//    void updateUser_shouldUpdateAndReturnUser() {
//        // given
//        Long id = 1L;
//        when(userRepository.findById(id)).thenReturn(Optional.of(userEntity));
//        when(userMapper.toEntity(userDto)).thenReturn(userEntity);
//        when(userRepository.save(any(UserEntity.class))).thenAnswer(invocation -> invocation.getArgument(0));
//
//        // when
//        UserEntity updated = userService.updateUser(id, userDto);
//
//        // then
//        assertNotNull(updated);
//        assertEquals("Ana", updated.getFirstName());
//        assertEquals("Silva", updated.getLastName());
//        assertEquals("12345678900", updated.getDocument());
//        assertEquals(LocalDate.of(1990, 1, 1), updated.getBirthday());
//        assertEquals("ana@email.com", updated.getEmail());
//
//        verify(userRepository).findById(id);
//        verify(userMapper).toEntity(userDto);
//        verify(userRepository).save(any(UserEntity.class));
//    }
//
//    @Test
//    void updateUser_shouldThrowException_whenUserNotFound() {
//        // given
//        Long id = 99L;
//        when(userRepository.findById(id)).thenReturn(Optional.empty());
//
//        // when + then
//        NoSuchElementException ex = assertThrows(NoSuchElementException.class,
//                () -> userService.updateUser(id, userDto));
//
//        assertEquals("User not found with id " + id, ex.getMessage());
//        verify(userRepository).findById(id);
//        verify(userRepository, never()).save(any());
//    }
//}
